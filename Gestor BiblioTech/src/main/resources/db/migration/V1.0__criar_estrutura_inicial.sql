-- ENUMS
CREATE type sexo as enum ('MASCULINO', 'FEMININO');
CREATE type status_exemplar as ENUM ('DISPONIVEL', 'EMPRESTADO', 'RESERVADO', 'PERDIDO');
CREATE type status_emprestimo as ENUM ('ATIVO', 'RENOVADO', 'ENCERRADO', 'EXPIRADO');
CREATE type status_reserva as ENUM ('PENDENTE', 'DISPONIVEL', 'EXPIRADO', 'CANCELADO');
CREATE type status_notificacao as ENUM ('PENDENTE', 'ENVIADO', 'EXPIRADO', 'CANCELADO');


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
	prazo_atraso_reserva INT NOT NULL DEFAULT 1, 
	prazo_atraso_devolucao INT NOT NULL DEFAULT 1,
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


CREATE TABLE leitor (
	id SERIAL NOT NULL PRIMARY KEY,
	id_endereco BIGINT NOT NULL,
	nome VARCHAR (45) NOT NULL,
	email VARCHAR (45) NOT NULL,
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
	nome VARCHAR (45) NOT NULL,
	email VARCHAR (45),
	website VARCHAR(45),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
	CONSTRAINT fk_editora_endereco
		FOREIGN KEY (id_endereco) REFERENCES endereco (id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

CREATE TABLE categoria (
	id SERIAL NOT NULL PRIMARY KEY,
	nome VARCHAR(45),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE autor (
	id SERIAL NOT NULL PRIMARY KEY,
	nome VARCHAR(45),
	data_nascimento DATE,
	data_falescimento DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE obra (
	id SERIAL NOT NULL PRIMARY KEY,
	id_categoria BIGINT NOT NULL,
	id_autor BIGINT NOT NULL,
	id_editora BIGINT NOT NULL,
	titulo VARCHAR (45) NOT NULL,
	sinopse TEXT,
	isbn VARCHAR (45),
	issn VARCHAR (45),
	edicao VARCHAR(45),
	volume INT,
	ano_lancamento DATE,
	qtd_paginas INT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
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
	id_exemplar BIGINT NOT NULL,
	status status_emprestimo,
	data_emprestimo DATE NOT NULL,
	data_vencimento_original DATE,
	data_vencimento_atual DATE,
	data_devolucao DATE,	
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

CREATE TABLE renovacao_emprestimo (
    id SERIAL NOT NULL PRIMARY KEY,
    id_emprestimo BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    data_renovacao DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_renovacao_emprestimo_emprestimo
        FOREIGN KEY (id_emprestimo) REFERENCES emprestimo (id)
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
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

