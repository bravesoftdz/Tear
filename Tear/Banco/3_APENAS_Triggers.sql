use balay;

-- Excluiu os operador_has_tipo_recurso do Operador excluído
DELIMITER //
CREATE TRIGGER TRIGGER_Operador_delete 
AFTER DELETE ON Operador for each row
BEGIN
	DELETE FROM operador_has_tipo_recurso WHERE operador_has_tipo_recurso.idOperador = old.idOperador;
END //
DELIMITER ;


-- Excluiu Fase_has_grupo do Grupo excluído
DELIMITER //
CREATE TRIGGER TRIGGER_Grupo_delete 
AFTER DELETE ON Grupo for each row
BEGIN
	DELETE FROM fase_has_grupo WHERE fase_has_grupo.idGrupo = old.idGrupo;
END //
DELIMITER ;


-- Exclui Batida e Cronomertagem_has_tipo_recurso do Cronometragem excluída
DELIMITER //
CREATE TRIGGER TRIGGER_Cronometragem_delete 
AFTER DELETE ON Cronometragem for each row
BEGIN
	-- Exclui cronometragem_has_tipo_recurso
	DELETE FROM cronometragem_has_tipo_recurso WHERE cronometragem_has_tipo_recurso.idCronometragem = old.idCronometragem;
    -- Exclui Batida
    DELETE FROM batida WHERE batida.idCronometragem = old.idCronometragem;
    -- Exclui Dependencias
    DELETE FROM dependencia WHERE dependencia.idCronometragem = old.idCronometragem;
END //
DELIMITER ;


-- Excluiu fases do Produto excluído
DELIMITER //
CREATE TRIGGER TRIGGER_Produto_delete 
AFTER DELETE ON produto for each row
BEGIN
	DELETE FROM produto_has_fase WHERE produto_has_fase.idProduto = old.idProduto;
END //
DELIMITER ;


-- Excluiu ordem_has_fase da Ordem excluída
DELIMITER //
CREATE TRIGGER TRIGGER_Ordem_delete 
AFTER DELETE ON ordem_producao for each row
BEGIN
	DELETE FROM ordem_has_fase WHERE ordem_has_fase.idOrdem = old.idOrdem;
END //
DELIMITER ;