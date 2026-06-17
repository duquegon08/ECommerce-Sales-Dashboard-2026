DROP VIEW IF EXISTS vw_amazon_dashboard;

CREATE OR REPLACE VIEW vw_amazon_dashboard AS
SELECT 
    p.asin AS producto_id,
    COALESCE(p.title, 'Sin Título') AS producto_nombre,
    COALESCE(p.price, 0) AS precio_actual,
    COALESCE(p."listPrice", p.price, 0) AS precio_lista_original,
    COALESCE(p.stars, 0) AS calificacion_estrellas,
    COALESCE(p.reviews, 0) AS total_resenas,
    
    -- ¡Aquí traemos el nombre real de la categoría cruzada!
    COALESCE(c.category_name, 'No Clasificado') AS categoria,
    
    -- Porcentaje de descuento
    CASE 
        WHEN p."listPrice" > 0 AND p."listPrice" > p.price 
        THEN ROUND(((p."listPrice" - p.price) / p."listPrice" * 100)::numeric, 2)
        ELSE 0 
    END AS porcentaje_descuento,
    
    -- Dinero ahorrado
    CASE 
        WHEN p."listPrice" > p.price THEN ROUND((p."listPrice" - p.price)::numeric, 2)
        ELSE 0 
    END AS descuento_dinero,
    
    -- Índice de popularidad
    ROUND((COALESCE(p.stars, 0) * COALESCE(p.reviews, 0))::numeric, 0) AS indice_popularidad
FROM amazon_products p
LEFT JOIN amazon_categories c 
    ON p.category_id = c.id; -- Conexión entre ambas tablas

SELECT * FROM vw_amazon_dashboard LIMIT 10;

