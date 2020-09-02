
SELECT 
	`name` as Nome, positive_ratings AS `Avaliações Positivas` 
FROM 
	steam 
WHERE 
	positive_ratings > 250500 
ORDER BY 
	positive_ratings 
DESC;



-- Pequena descrição dos 3 primeiros jogos mais baratos 

SELECT 
	tabJogos.name "Jogo",
	tabDescricao.short_description "Descrição",
    tabJogos.price "Preço"
FROM
	steam_description_data tabDescricao
INNER JOIN
	steam tabJogos ON tabJogos.appid = tabDescricao.steam_appid
WHERE
	tabJogos.price <> 0
ORDER BY 
	price
LIMIT 
    3;

-- A soma da quantidade de zumbies que os jogos left 4 dead e left 4 dead 2 tem 

SELECT
	sum(soma) 'Soma zumbis'
FROM
(SELECT
    tabCaracteristicasDoJogo.zombies soma
FROM
	steamspy_tag_data tabCaracteristicasDoJogo
INNER JOIN
	steam tabJogos ON tabJogos.appid = tabCaracteristicasDoJogo.appid
WHERE 
	tabJogos.name like 'Left 4 Dead'
	UNION 
SELECT
    tabCaracteristicasDoJogo.zombies soma
FROM
	steamspy_tag_data tabCaracteristicasDoJogo
INNER JOIN
	steam tabJogos ON tabJogos.appid = tabCaracteristicasDoJogo.appid
WHERE 
	tabJogos.name like 'Left 4 Dead %') soma;

-- Top 5 jogos mais positivamente avaliados publicados pela SQUARE ENIX

SELECT 
	name 'Jogo',
    positive_ratings 'Rank +'
FROM
	steam
WHERE 
	developer like '%Square%'
ORDER BY
	  positive_ratings DESC
LIMIT
	 5;

-- Top 10 jogos gratuitos mais baixados

SELECT 
    `name` Jogo,
    developer Desenvolvedor,
    owners Proprietarios,
    publisher Empresa,
    platforms Plataformas,
    categories Categorias,
    genres Gêneros,
    steamspy_tags TipoDeJogo,
    positive_ratings 'Rank +',
    negative_ratings 'Rank -'
FROM
    steam
WHERE
    price = 0
ORDER BY owners DESC
LIMIT 10;

-- Top 10 jogos pagos mais baixados

SELECT 
`name` Jogo,
    developer Desenvolvedor,
    owners Proprietários,
    publisher Empresa,
    platforms Plataformas,
    categories Categorias,
    genres Gêneros,
    steamspy_tags TipoDeJogo,
    positive_ratings 'Rank +',
    negative_ratings 'Rank -'
FROM
    steam
WHERE
    price <> 0
ORDER BY owners DESC
LIMIT 10;


-- 5 jogos que possuem suporte ao usuario
SELECT 
    STEAM.`NAME` AS Nome, 
    SUPORTE.SUPPORT_URL AS Site 
FROM 
	`steam` AS STEAM 
INNER JOIN `steam_support_info` AS SUPORTE
		ON STEAM.APPID = SUPORTE.STEAM_APPID 
WHERE 
	LENGTH(SUPORTE.SUPPORT_URL) > 0
LIMIT 5;

-- top 10 jogos com valor acima de 100 reais?
SELECT 
	STEAM.`NAME` Jogo,
	STEAM.PRICE 'Preço em $'
FROM 
	`steam` AS STEAM 
WHERE 
	PRICE > 100 
ORDER BY 
	STEAM.PRICE LIMIT 10;

-- top 10 jogos com valor abaixo de 10 reais

SELECT 
	STEAM.`NAME` Jogo,
	STEAM.PRICE 'Preço em $'
FROM 
	`steam` AS STEAM 
WHERE 
	PRICE <= 10
ORDER BY STEAM.PRICE DESC LIMIT 10;

-- Classificar as avaliações positivas em otimo, bom, regular e ruim

CREATE 
    ALGORITHM = UNDEFINED 
    SQL SECURITY DEFINER
VIEW `VW_AVALIACAO` AS
    SELECT 
        `STEAM`.`positive_ratings` AS `POSITIVE_RATINGS`,
        (CASE
            WHEN (`STEAM`.`positive_ratings` > 250500) THEN 'ÓTIMO'
            WHEN
                ((`STEAM`.`positive_ratings` > 52000)
                    AND (`STEAM`.`positive_ratings` < 150000))
            THEN
                'BOM'
            WHEN
                ((`STEAM`.`positive_ratings` < 51000)
                    OR (`STEAM`.`positive_ratings` > 0))
            THEN
                'REGULAR'
            ELSE 'SEM AVALIAÇÃO'
        END) AS `AVAL_POSITIVA`
    FROM
        `steam` `STEAM`;


-- Contar as avaliações positivas em otimo, bom, regular e ruim

SELECT 
	AVAL_POSITIVA AS Classificação, 
    COUNT(AVAL_POSITIVA) AS Total 
FROM 
	VW_AVALIACAO 
GROUP BY 
	AVAL_POSITIVA ORDER BY TOTAL DESC;

-- 5 jogos que têm trailer
SELECT 
	STEAM.APPID AS ID, 
    STEAM.`NAME` AS NOME, 
    TRAILLER.MOVIES AS FILME 
FROM 
	`steam` AS STEAM 
INNER JOIN 
	`steam_media_data` TRAILLER
ON 
	STEAM.APPID = TRAILLER.STEAM_APPID 
WHERE 
	LENGTH(TRAILLER.MOVIES) > 0
LIMIT 5;

-- Média de preço dos jogos por desenvolvedores?

SELECT 
	STEAM.DEVELOPER, ROUND(AVG(PRICE),2) AS MEDIA_PREÇO 
FROM 
	`steam` AS STEAM 
GROUP BY 
	STEAM.DEVELOPER 
ORDER BY MEDIA_PREÇO DESC LIMIT 10;

