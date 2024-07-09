CREATE TABLE `tb` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `dict` json NOT NULL,
  `array` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `tb`(`dict`, `array`) VALUES (
    JSON_OBJECT("key1", "value1", "key2", "value2"),
    JSON_ARRAY("a", "b")
);

SELECT JSON_EXTRACT(`dict`, "$.key1") FROM `tb`;
-- "value1"
SELECT JSON_EXTRACT(`array`, "$[1]") FROM `tb`;
-- b

SELECT JSON_CONTAINS(`dict`, '"value1"', "$.key1") FROM `tb`;
-- 1
SELECT JSON_CONTAINS(`array`, "b") FROM `tb`;
-- 1

SELECT JSON_CONTAINS_PATH(`array`, "all", "$[0]") FROM `tb`;
-- 1
SELECT JSON_CONTAINS_PATH(`array`, "one", "$[0]", "$[0].x") FROM `tb`;
-- 1
-- one表示有一个路径满足即可
SELECT JSON_CONTAINS_PATH(`array`, "all", "$[0]", "$[0].x") FROM `tb`;
-- 0
-- all表示所有路径均满足

SELECT JSON_LENGTH(`dict`), JSON_LENGTH(`array`) FROM `tb`;
-- 2, 2

-- JSON_INSERT只能插入到不存在的位置
SELECT JSON_INSERT(`dict`, "$.key2", "value2.1") FROM `tb`;
-- { "key1": "value1", "key2": "value2" }
SELECT JSON_INSERT(`dict`, "$.key3", "value2.1") FROM `tb`;
-- { "key1": "value1", "key2": "value2", "key3": "value2.1" }

-- JSON_TABLE必须有alias
-- JSON_TABLE使用表中json字段的一般形式
SELECT t.* FROM tb, JSON_TABLE(`dict`, '$.*' COLUMNS (value varchar(10) PATH '$')) as t;
-- JSON_TABLE ORDINALITY
SELECT
    *
FROM
    JSON_TABLE(
        '[{"x": 10, "y": 11}, {"x": 20, "y": 21}]',
        '$[*]'
        COLUMNS (
            id FOR ORDINALITY,
            x INT PATH '$.x',
            y INT PATH '$.y'
        )
    ) AS t;
-- id x y
-- 1 10 11
-- 2 20 21

-- JSON_TABLE拉平内嵌数组
SELECT
    *
FROM
    JSON_TABLE(
        '[{"x":10,"y":[11, 12]}, {"x":20,"y":[21, 22]}]',
        '$[*]'
        COLUMNS (
            x INT PATH '$.x',
            NESTED PATH '$.y[*]' COLUMNS (y INT PATH '$')
        )
    ) AS t;
-- x y
-- 10 11
-- 10 12
-- 20 21
-- 20 22
