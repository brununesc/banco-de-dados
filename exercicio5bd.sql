/*5. Quando realizamos uma venda de um produto, o preço de venda desse produto
vem da tabela de produtos automaticamente. Criar uma trigger para buscar o valor 
de venda do produto no momento da venda do mesmo.*/  
DELIMITER //
DROP TRIGGER IF EXISTS buscar_valor_venda //
CREATE TRIGGER buscar_valor_venda
BEFORE INSERT ON itens_nfv
FOR EACH ROW
BEGIN
   IF (new.id_produto IN (SELECT id_produto 
                          FROM produtos)) THEN  /*insert = new , delete/update = old*/
   SET new.pvenda = (SELECT venda FROM produtos
                     WHERE id_produto=new.id_produto); #set busca o valor
   END IF;

END //
DELIMITER ;

#aplicação#
INSERT INTO itens_nfv (id_nfv,id_produto,quantidade,pvenda)
VALUES (6,1,2,0)