import re
from datetime import datetime
from typing import Optional, Sequence

import sqlalchemy as sa
import sqlalchemy.dialects.mysql as sa_mysql
import sqlalchemy.event as event
import sqlalchemy.orm as sa_orm
from sqlalchemy.orm.session import ORMExecuteState

user, password, host, port, database = "root", "password", "localhost", 3306, "database"
"""存在转义字符需要用urllib.parse.quote转义"""
engine = sa.create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")
"""建立连接，不同的引擎需要安装不同的DB引擎，pymysql: pip install pymysql"""

scoped_session = sa_orm.scoped_session(sa_orm.sessionmaker(bind=engine))
"""session工厂，无需单独创建Session对象，scope默认为threading.local()，
flask的scope可考虑使用flask_sqlalchemy"""


class Base(sa_orm.DeclarativeBase):
    """所有实体类型均需要集成该类"""

    id: sa_orm.Mapped[int] = sa_orm.mapped_column(
        sa_mysql.INTEGER(unsigned=True),
        primary_key=True,
        nullable=False,
        autoincrement="auto",
    )
    created_at: sa_orm.Mapped[datetime] = sa_orm.mapped_column(
        sa_mysql.TIMESTAMP,
        nullable=False,
        server_default=sa.text("CURRENT_TIMESTAMP"),
        comment="创建时间",
    )
    updated_at: sa_orm.Mapped[datetime] = sa_orm.mapped_column(
        sa_mysql.TIMESTAMP,
        nullable=False,
        server_default=sa.text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
        comment="修改时间",
    )

    @sa_orm.declared_attr.directive
    def __tablename__(cls) -> str:
        """使得类名到数据库表名的默认映射关系为驼峰到下划线"""
        return re.sub(
            "(?<=[a-z])[A-Z]|(?<!^)[A-Z](?=[a-z])", r"_\g<0>", cls.__name__
        ).lower()


class SoftDelete:
    """软删除"""

    deleted_at: sa_orm.Mapped[Optional[datetime]] = sa_orm.mapped_column(
        sa_mysql.TIMESTAMP, nullable=True, comment="删除时间"
    )


class UserInfo:
    birthday: str
    gender: bool


class User(Base):
    name: sa_orm.Mapped[str] = sa_orm.mapped_column(
        sa_mysql.VARCHAR(30), nullable=False, comment="名称"
    )

    info: sa_orm.Mapped[UserInfo] = sa_orm.mapped_column(
        sa_mysql.JSON,
        nullable=False,
        default=sa.text("JSON_OBJECT()"),
        comment="固定信息",
    )


def create_tables():
    """创建表，包括实体类已经被import的表"""
    Base.metadata.create_all(engine)


def soft_delete():
    """软删除，仅对查询和子查询中的主mapper做软删除过滤，其他复杂情况需要手动添加\n
    软删除的时候仅对单表进行软删除处理"""

    def listen(orm_execute_state: ORMExecuteState):
        if (
            (orm_execute_state.is_select or orm_execute_state.is_update)
            and not orm_execute_state.is_column_load
            and not orm_execute_state.is_relationship_load
            and not orm_execute_state.execution_options.get("ignore_soft_delete")
        ):
            # 查询和子查询中的主mapper进行软删除过滤
            orm_execute_state.statement = orm_execute_state.statement.options(
                sa_orm.with_loader_criteria(
                    SoftDelete,
                    lambda cls: cls.deleted_at.is_(None),
                    include_aliases=True,
                )
            )

        if orm_execute_state.is_delete and not orm_execute_state.execution_options.get(
            "ignore_soft_delete"
        ):
            if len(orm_execute_state.all_mappers) == 1 and issubclass(
                orm_execute_state.all_mappers[0].entity, SoftDelete
            ):
                # 仅处理单表简单软删除
                orm_execute_state.statement = (
                    sa.update(orm_execute_state.all_mappers[0].entity)
                    .where(orm_execute_state.statement.whereclause)  # type: ignore[attr-defined] # noqa: E501
                    .where(orm_execute_state.all_mappers[0].entity.deleted_at.is_(None))
                    .values({"deleted_at": sa.func.now()})
                )

    event.listen(scoped_session, "do_orm_execute", listen)


"""orm操作示例"""


def get_user(id: int) -> Optional[User]:
    """ignore_soft_delete忽略软删除"""
    return scoped_session.get(User, id, execution_options={"ignore_soft_delete": True})


def list_user_by_name(names: list[str]) -> Sequence[User]:
    return (
        scoped_session.execute(sa.select(User).where(User.name.in_(names)))
        .scalars()
        .all()
    )
