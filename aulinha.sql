###=========================###
###======= TRIGGERS ========###
###=========================###

/*Gatilho é um objeto de banco de dados, associado a 
uma tabela, definido para ser disparado ou acionado, 
respondendo a um evento em particular. 

Tais eventos são os comandos DML: */
   INSERT, DELETE ou UPDATE


/*Podemos definir inúmeros*/ TRIGGERS /*em uma base de 
dados baseados diretamente em qual dos comandos acima 
irá dispará-lo, sendo que, para cada um, podemos 
definir apenas um gatilho.

Os TRIGGERS poderão ser disparados antes*/

BEFORE - AFTER /* do evento*/.

### Sintaxe ###

DELIMITER //
DROP TRIGGER IF EXISTS nome_da_trigger //

CREATE TRIGGER nome_da_trigger 
AFTER/BEFORE  /*momento*/
INSERT/UPDATE/DELETE ON nome_da_tabela /*evento*/
FOR EACH ROW /*para cada linha*/
BEGIN
     ## corpo da triggers - ações ##          
     ## query´s...........;
END//
DELIMITER  ;

#Apagando uma trigger
DROP TRIGGER nome_da_trigger;

#Visualizando todas as triggers
SHOW TRIGGERS 

/*Operadores : NEW e OLD.

Em gatilhos executados após a inserção de registros, 
a palavra reservada NEW dá acesso ao novo registro. 
Pode-se acessar as colunas da tabela como atributo 
do registro NEW.

O operador OLD funciona de forma semelhante, porém 
em gatilhos que são executados com a exclusão
de dados
*/

/*Exemplos/*

/*1.Quando realizamos uma venda de um produto 
precisamos atualizar o estoque dando baixa na 
quantidade vendida do produto.
Criar uma trigger para realizar essa tarefa*/

DELIMITER //
DROP TRIGGER IF EXISTS tr_venda_produtos //
CREATE TRIGGER tr_venda_produtos
AFTER INSERT ON itens_nfv
FOR EACH ROW
BEGIN
 ## ação a ser realizada ##
 UPDATE produtos SET /*altera*/ estoque = estoque - new.quantidade
 WHERE id_produto = new.id_produto;
END//
DELIMITER ;

#Aplicação#
### evento externo  ###

INSERT INTO itens_nfv
           (id_nfv,id_produto,quantidade,pvenda)
VALUES (1,10,2,72.48);


### Acão - realizada na trigger ###
UPDATE .......

/*2.Criar uma trigger para atualizar o estoque do produto 
quando o mesmo for deletado dos itens de venda.*/
DELIMITER //
DROP TRIGGER IF EXISTS atualiza_estoque //
CREATE TRIGGER atualiza_estoque
AFTER DELETE ON itens_nfv 
FOR EACH ROW
BEGIN
UPDATE produtos SET estoque = estoque + old.quantidade
WHERE id_produto = old.id_produto;
END // 
DELIMITER ;
#Gatilho

#Evento externo - Aplicação

DELETE FROM itens_nfv
WHERE id_nfv = 1 AND id_produto = 10; 
	
/*3.Criar um gatilho que no momento de deletar uma 
nota fiscal de venda verifique se a mesma possui 
itens. Caso afirmativo primeiro deleta os itens 
da NF e depois o cabeçalho da nota.*/
DELIMITER //
DROP TRIGGER IF EXISTS deletar_nfv //
CREATE TRIGGER deletar_nfv
BEFORE DELETE ON nf_vendas
FOR EACH ROW
BEGIN
   IF (old.id_nfv IN (SELECT id_nfv FROM itens_nfv)) THEN 
   DELETE FROM itens_nfv WHERE old.id_nfv = id_nfv;
   END IF;
END//
DELIMITER ;

#Evento

DELETE FROM nf_vendas
WHERE id_nfv = 4;

/*4.Criar uma trigger que identifique se o cliente 
faz aniversário no mesmo mes da compra que esta 
efetuando e de um desconto de 20% no valor da nota 
fiscal do mesmo*/

#Gatilho
DELIMITER //
DROP TRIGGER IF EXISTS desconto_nf //
CREATE TRIGGER desconto_nf
BEFORE INSERT ON nf_vendas
FOR EACH ROW
BEGIN
   IF (MONTH(CURRENT_DATE)=(SELECT MONTH(datanasc)FROM clientes WHERE id_cliente = new.id_cliente)) THEN
   SET new.valor = new.valor - (new.valor*0.20);
   
 END IF;
 END//
DELIMITER ;
   /*set new.valor = new.valor*0.80*/
#evento 
INSERT INTO nf_vendas (emissao, valor, id_fp, id_vendedor, id_cliente)
VALUES (CURRENT_DATE, 500.00, 1, 1, 5)

