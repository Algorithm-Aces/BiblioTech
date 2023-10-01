CREATE type sexo as enum ('MASCULINO', 'FEMININO');
CREATE type tipo_autor as ENUM('PESSOA', 'INSTITUIÇÃO', 'CONVENÇÃO');
CREATE type estado_exemplar as ENUM ('BOM', 'DANIFICADO', 'PERDIDO');
CREATE type status_exemplar as ENUM ('DISPONIVEL', 'EMPRESTADO', 'RESERVADO', 'EM MANUTENÇÃO');
CREATE type status_emprestimo as ENUM ('ATIVO', 'RENOVADO', 'ENCERRADO');
CREATE type status_reserva as ENUM ('PENDENTE', 'DISPONIVEL', 'EXPIRADO', 'CANCELADO');
CREATE type status_notificacao as ENUM ('PENDENTE', 'ENVIADO', 'EXPIRADO', 'CANCELADO');
CREATE type motivo_multa as ENUM ('ATRASO_DEVOLUCAO', 'DANOS_MATERIAIS', 'PERDA_MATERIAL');
CREATE type metodo_pagamento as ENUM ('DINHEIRO');

CREATE TABLE endereco (
	id SERIAL NOT NULL PRIMARY KEY,
	cep CHAR(8) NOT NULL,
	uf CHAR(2) NOT NULL,
	cidade VARCHAR(45) NOT NULL,
	logradouro VARCHAR(45) NOT NULL,
	bairro VARCHAR(45) NOT NULL,
	numero INT NOT NULL,
	complemento VARCHAR(45) NOT null,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario (
	id SERIAL NOT NULL PRIMARY KEY,
	id_endereco BIGINT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	email VARCHAR(45) NOT NULL UNIQUE,
	senha VARCHAR(45) NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	cpf CHAR(11) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	sexo sexo,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_usuario_endereco
		FOREIGN KEY (id_endereco) REFERENCES endereco (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE privilegio (
	id SERIAL NOT NULL PRIMARY KEY,
	titulo VARCHAR(45) NOT NULL,
	descricao VARCHAR(270),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario_privilegio (
	id_usuario BIGSERIAL NOT NULL,
	id_privilegio BIGSERIAL NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_usuario_privilegio_usuario
		FOREIGN KEY (id_usuario) REFERENCES usuario (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		
	CONSTRAINT fk_usuario_privilegio_privilegio
		FOREIGN KEY (id_privilegio) REFERENCES privilegio (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE biblioteca (
	id SERIAL NOT NULL PRIMARY KEY,
	id_endereco BIGINT NOT NULL,
	nome VARCHAR (45) NOT NULL,
	email VARCHAR (45),
	telefone VARCHAR(20) NOT NULL,
	valor_multa_atraso DECIMAL(10, 2) NOT NULL,
	juros_diario_atraso DECIMAL(10, 2)	NOT NULL,
	prazo_atraso_reserva INT NOT NULL DEFAULT 1, 
	prazo_atraso_devolucao INT NOT NULL DEFAULT 1,
	prazo_renovacao INT NOT NULL DEFAULT 2,
	qtd_dias_emprestimo INT NOT NULL DEFAULT 14,
	limite_dias_emprestimo INT NOT NULL DEFAULT 56,
	limite_livros_emprestimo INT NOT NULL DEFAULT 1,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_biblioteca_endereco
		FOREIGN KEY (id_endereco) REFERENCES endereco (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

COMMENT ON COLUMN biblioteca.prazo_atraso_reserva IS 'O valor é contado em dias';
COMMENT ON COLUMN biblioteca.prazo_atraso_devolucao IS 'O valor é contado em dias';
COMMENT ON COLUMN biblioteca.qtd_dias_emprestimo IS 'O valor é contado em dias';
COMMENT ON COLUMN biblioteca.limite_dias_emprestimo IS 'O valor é contado em dias';
COMMENT ON COLUMN biblioteca.limite_livros_emprestimo IS 'O valor é contado em dias';

CREATE TABLE leitor (
	id SERIAL NOT NULL PRIMARY KEY,
	id_endereco BIGINT NOT NULL,
	nome VARCHAR (45) NOT NULL,
	email VARCHAR (45),
	telefone VARCHAR (20) NOT NULL,
	data_nascimento DATE NOT NULL,
	cpf CHAR(11) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_leitor_endereco
		FOREIGN KEY (id_endereco) REFERENCES endereco (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE editora (
	id SERIAL NOT NULL PRIMARY KEY,
	id_endereco BIGINT NOT NULL,
	website VARCHAR(45),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
	CONSTRAINT fk_editora_endereco
		FOREIGN KEY (id_endereco) REFERENCES endereco (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE serie (
	id SERIAL NOT NULL PRIMARY KEY,
	autor BIGINT NOT NULL,
	titulo VARCHAR (90) NOT NULL,
	descricao TEXT,
	data_lancamento DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categoria (
	id SERIAL NOT NULL PRIMARY KEY,
	nome VARCHAR(45),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE autor (
	id SERIAL NOT NULL PRIMARY KEY,
	tipo tipo_autor NOT NULL,
	nome VARCHAR(45),
	data_nascimento DATE,
	data_falescimento DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE obra (
	id SERIAL NOT NULL PRIMARY KEY,
	id_serie BIGINT,
	id_categoria BIGINT NOT NULL,
	id_autor BIGINT NOT NULL,
	id_editora BIGINT NOT NULL,
	titulo VARCHAR (45) NOT NULL,
	titulo_paralelo VARCHAR (45),
	sinopse TEXT,
	capa VARCHAR (45),
	isbn VARCHAR (45),
	issn VARCHAR (45),
	edicao VARCHAR(45),
	volume INT,
	ano_lancamento DATE,
	qtd_paginas INT,
	valor DECIMAL(10, 2) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
	CONSTRAINT fk_obra_serie
		FOREIGN KEY (id_serie) REFERENCES serie (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
		
	CONSTRAINT fk_obra_editora
		FOREIGN KEY (id_editora) REFERENCES editora (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
		
	CONSTRAINT fk_obra_categoria
		FOREIGN KEY (id_categoria) REFERENCES categoria (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
		
	CONSTRAINT fk_obra_autor
		FOREIGN KEY (id_autor) REFERENCES autor (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE exemplar (
	id SERIAL NOT NULL PRIMARY KEY,
	id_obra BIGINT NOT NULL,
	codigo VARCHAR(20) NOT NULL,
	estado estado_exemplar NOT NULL,
	status status_exemplar NOT NULL,
	data_aquisicao DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_exemplar_obra
		FOREIGN KEY (id_obra) REFERENCES obra (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE emprestimo (
	id SERIAL NOT NULL PRIMARY KEY,
	id_leitor BIGINT NOT NULL,
	id_usuario BIGINT NOT NULL,
	status status_emprestimo,
	data_emprestimo DATE NOT NULL,
	data_vencimento DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_emprestimo_leitor
		FOREIGN KEY (id_leitor) REFERENCES leitor (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	
	CONSTRAINT fk_emprestimo_usuario
		FOREIGN KEY (id_usuario) REFERENCES usuario (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE

);

CREATE TABLE emprestimo_item (
	id SERIAL NOT NULL PRIMARY KEY,
	id_emprestimo BIGINT NOT NULL,
	id_exemplar BIGINT NOT NULL,
	data_vencimento_atual DATE,
	data_devolucao DATE,	
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_emprestimo_item_emprestimo
		FOREIGN KEY (id_emprestimo) REFERENCES emprestimo (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		
	CONSTRAINT fk_emprestimo_item_exemplar
		FOREIGN KEY (id_exemplar) REFERENCES exemplar (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE renovacao_emprestimo (
    id SERIAL NOT NULL PRIMARY KEY,
    id_emprestimo_item BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    data_renovacao DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_renovacao_emprestimo_emprestimo_item
        FOREIGN KEY (id_emprestimo_item) REFERENCES emprestimo_item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_renovacao_emprestimo_usuario
		FOREIGN KEY (id_usuario) REFERENCES usuario (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE reserva (
    id SERIAL NOT NULL PRIMARY KEY,
    id_leitor BIGINT NOT null,
    id_usuario BIGINT NOT null,
    id_obra BIGINT NOT null,
	status status_reserva NOT NULL DEFAULT 'PENDENTE',
	data_reserva DATE NOT null,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_reserva_leitor
		FOREIGN KEY (id_leitor) REFERENCES leitor (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	
	CONSTRAINT fk_reserva_usuario
		FOREIGN KEY (id_usuario) REFERENCES usuario (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	
	CONSTRAINT fk_reserva_obra
		FOREIGN KEY (id_obra) REFERENCES obra (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE

);

CREATE TABLE notificacao_reserva (
    id SERIAL NOT NULL PRIMARY KEY,
    id_reserva BIGINT NOT NULL,
	status status_notificacao NOT NULL DEFAULT 'PENDENTE',
	data_notificacao DATE NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT notificacao_reserva_reserva
		FOREIGN KEY (id_reserva) REFERENCES reserva (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE multa_emprestimo (
	id SERIAL NOT NULL PRIMARY KEY,
	id_emprestimo BIGINT NOT NULL,
	id_emprestimo_item BIGINT NOT NULL,
	valor DECIMAL (10,2) NOT NULL,
	motivo motivo_multa NOT NULL,
	descricao TEXT,
	status_pagamento BOOLEAN NOT NULL DEFAULT false,
	data_missao TIMESTAMP NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_multa_emprestimo_emprestimo
        FOREIGN KEY (id_emprestimo) REFERENCES emprestimo (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

	CONSTRAINT fk_multa_emprestimo_emprestimo_item
		FOREIGN KEY (id_emprestimo_item) REFERENCES emprestimo_item (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE     
);


CREATE TABLE transacao_financeira (
	id SERIAL NOT NULL PRIMARY KEY,
	id_multa_emprestimo BIGINT NOT NULL,
	metodo_pagamento metodo_pagamento NOT NULL,
	data_pagamento TIMESTAMP NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_transacao_financeira_multa_emprestimo
        FOREIGN KEY (id_multa_emprestimo) REFERENCES multa_emprestimo (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE pagamento_dinheiro (
	id SERIAL NOT NULL PRIMARY KEY,
	id_transacao_financeira BIGINT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	
	CONSTRAINT fk_pagamento_dinheiro_transacao_financeira
        FOREIGN KEY (id_transacao_financeira) REFERENCES transacao_financeira (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

