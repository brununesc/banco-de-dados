/*6. A loja deseja fazer uma promoção de vendas de seus produtos baseada na idade
do cliente. Criar uma trigger que seja disparado quando a loja realizar uma venda
para o cliente. O gatilho tem como objetivo conceder descontos no valor da nota 
fiscal de venda de acordo com a tabela abaixo, para isso deverá identificar 
a idade do cliente que está comprando.

### Tabela de descontos ###
===========================
Idade do cliente         Descontos `fatecvan`em %
----------------         --------------
Menor do que 30 anos           5%
Entre 30 anos e 50 anos        8%
Acima de 50 anos               10%*/

DELIMITER //
DROP TRIGGER IF EXISTS desconto_idade//
CREATE TRIGGER desconto_idade
BEFORE INSERT ON nf_vendas
FOR EACH ROW 
BEGIN
   DECLARE idade INT;
   SET idade = YEAR(new.emissao) - (SELECT YEAR (datanasc)
      FROM clientes WHERE id_cliente=new.id_cliente);
   IF (idade<30) THEN
     SET new.valor = new.valor*0.95;
   ELSE
      IF (idade BETWEEN 30 AND 50) THEN
         SET new.valor = new.valor*0.92;
      ELSE
         SET new.valor = new.valor*0.90;
      END IF;
   END IF;

END //
DELIMITER ;

### aplicação ###
INSERT INTO nf_vendas (emissao,valor,id_fp,id_vendedor,id_cliente)
VALUES (CURRENT_DATE,1000,1,1,2); #idade < 30

INSERT INTO nf_vendas (emissao,valor,id_fp,id_vendedor,id_cliente)
VALUES (CURRENT_DATE,1000,1,1,4); #idade 30 e 50

INSERT INTO nf_vendas (emissao,valor,id_fp,id_vendedor,id_cliente)
VALUES (CURRENT_DATE,1000,1,1,6); #idade > 50

/*select id_cliente, year(current_date) - year(datanasc)
from clientes*/