
-- Pequena descrição dos 3 primeiros jogos mais baratos 

SELECT 
	tabJogos.name "Jogo",
	tabDescricao.short_description "Descrição",
    tabJogos.price "Preço em $"
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
    positive_ratings 'Rank +',
    CASE
            WHEN positive_ratings > 250500 THEN 'ÓTIMO'
            WHEN (positive_ratings > 52000 AND positive_ratings < 150000) THEN 'BOM'
            WHEN (positive_ratings < 51000 OR positive_ratings > 0) THEN 'REGULAR'
            ELSE 'SEM AVALIAÇÃO'
END AS `Classificação`
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


-- 5 jogos que possuem suporte ao usuario ordenados pelo ranking
SELECT 
    STEAM.`NAME` AS Nome, 
    STEAM.genres Categoria,
    SUPORTE.SUPPORT_URL AS Site 
FROM 
	`steam` AS STEAM 
INNER JOIN `steam_support_info` AS SUPORTE
		ON STEAM.APPID = SUPORTE.STEAM_APPID 
WHERE 
	LENGTH(SUPORTE.SUPPORT_URL) > 0
ORDER BY 
	STEAM.positive_ratings DESC
LIMIT 5;

-- Top 10 jogos com valor acima de 100 dolares
SELECT 
	NAME Jogo,
	PRICE 'Preço em $',
    PLATFORMS Plataformas,
    GENRES Categoria
FROM 
	steam
WHERE 
	PRICE > 100 
ORDER BY 
	PRICE LIMIT 10;

-- Top 10 jogos com valor abaixo de 10 dolares

SELECT 
	NAME Jogo,
	PRICE 'Preço em $',
    PLATFORMS Plataformas,
    genres Categoria
FROM 
	steam
WHERE 
	PRICE <= 10
ORDER BY PRICE DESC LIMIT 10;

-- View pra classificar as avaliações positivas em otimo, bom, regular e ruim

CREATE 
    ALGORITHM = UNDEFINED 
    SQL SECURITY DEFINER
VIEW `VW_AVALIACAO` AS
    SELECT 
        `STEAM`.`positive_ratings` AS `POSITIVE_RATINGS`,
        (CASE
            WHEN `STEAM`.`positive_ratings` > 150000 THEN 'ÓTIMO'
            WHEN `STEAM`.`positive_ratings` > 52000 AND `STEAM`.`positive_ratings` < 149999 THEN 'BOM'
            WHEN `STEAM`.`positive_ratings` > 31000 AND `STEAM`.`positive_ratings` < 51999 THEN 'REGULAR'
            WHEN `STEAM`.`positive_ratings` > 0 AND `STEAM`.`positive_ratings` < 30999 THEN 'RUIM'
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
	AVAL_POSITIVA ORDER BY Classificação;

-- 5 jogos que têm trailer ordenados pelo ranking
SELECT 
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
ORDER BY 
	STEAM.positive_ratings
LIMIT 5;

-- Média de preço dos jogos por desenvolvedores?

SELECT 
	STEAM.DEVELOPER, 
    ROUND(AVG(PRICE),2) AS MEDIA_PREÇO 
FROM 
	`steam` AS STEAM 
GROUP BY 
	STEAM.DEVELOPER 
ORDER BY MEDIA_PREÇO DESC LIMIT 10;

-- Os jogos que tiveram a avaliação "ótima"

SELECT 
    `name` AS Jogo,
    genres Categorias,
CASE 
	WHEN positive_ratings > 150000 THEN 'ÓTIMO'
END 'Avaliações Positivas'
FROM
    steam
WHERE
    positive_ratings > 150000 
ORDER BY positive_ratings DESC;
	
    