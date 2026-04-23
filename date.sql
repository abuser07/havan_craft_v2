-- ============================================================================
-- SISTEMA DE CRAFT - TABELAS SQL
-- ============================================================================

-- 1. Tabela principal do sistema de farmsystem
-- Armazena os itens que os jogadores depositaram no sistema
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_farmsystem` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `itens` LONGTEXT NOT NULL,
    `day` INT(11) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_day` (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 2. Tabela de storage/armazenamentos
-- Armazena os itens nos armazéns das bancadas
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_storages` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `storage_name` VARCHAR(100) NOT NULL,
    `storage_data` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_storage_name` (`storage_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 3. Tabela de logs de craft
-- Registra todas as ações de craft dos jogadores
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_craft_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `action` VARCHAR(50) NOT NULL,
    `item_name` VARCHAR(100) NOT NULL,
    `amount` INT(11) NOT NULL,
    `craft_type` VARCHAR(50) DEFAULT NULL,
    `location_id` VARCHAR(50) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_action` (`action`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 4. Tabela de histórico de transações do storage
-- Registra depósitos e retiradas dos armazéns
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_storage_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `storage_name` VARCHAR(100) NOT NULL,
    `item_name` VARCHAR(100) NOT NULL,
    `amount` INT(11) NOT NULL,
    `transaction_type` ENUM('deposit', 'withdraw', 'craft_use') NOT NULL,
    `craft_item` VARCHAR(100) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_storage_name` (`storage_name`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 5. Tabela de rotas (farm/coleta)
-- Armazena o progresso das rotas dos jogadores
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_route_progress` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `route_type` VARCHAR(20) NOT NULL,
    `current_point` INT(11) NOT NULL DEFAULT 1,
    `total_points` INT(11) NOT NULL,
    `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `completed_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_route_type` (`route_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 6. Tabela de permissões de bancada (opcional)
-- Para controle mais granular de quem pode usar cada bancada
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_craft_permissions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `craft_type` VARCHAR(50) NOT NULL,
    `location_id` VARCHAR(50) NOT NULL,
    `permission_level` ENUM('view', 'craft', 'admin') DEFAULT 'craft',
    `granted_by` VARCHAR(50) DEFAULT NULL,
    `granted_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_craft_location` (`user_id`, `craft_type`, `location_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_craft_type` (`craft_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 7. Tabela de estatísticas dos jogadores
-- Para acompanhamento de uso do sistema
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_craft_stats` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(50) NOT NULL,
    `total_crafts` INT(11) NOT NULL DEFAULT 0,
    `total_items_crafted` INT(11) NOT NULL DEFAULT 0,
    `total_items_deposited` INT(11) NOT NULL DEFAULT 0,
    `total_items_withdrawn` INT(11) NOT NULL DEFAULT 0,
    `last_craft_at` TIMESTAMP NULL DEFAULT NULL,
    `total_craft_time` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 8. Tabela de configurações do sistema
-- Para configurações dinâmicas sem precisar recarregar o script
-- ============================================================================
CREATE TABLE IF NOT EXISTS `sjr_system_config` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `config_key` VARCHAR(100) NOT NULL,
    `config_value` TEXT NOT NULL,
    `description` TEXT DEFAULT NULL,
    `updated_by` VARCHAR(50) DEFAULT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- INSERTS PADRÃO
-- ============================================================================

-- Inserir configurações padrão
INSERT INTO `sjr_system_config` (`config_key`, `config_value`, `description`) VALUES
('craft_enabled', 'true', 'Sistema de craft habilitado/desabilitado'),
('max_concurrent_crafts', '3', 'Número máximo de crafts simultâneos por jogador'),
('default_craft_time', '10', 'Tempo padrão de craft em segundos'),
('log_level', 'info', 'Nível de logging: debug, info, warn, error'),
('webhook_enabled', 'true', 'Webhook do Discord habilitado/desabilitado')
ON DUPLICATE KEY UPDATE config_key = config_key;

-- ============================================================================
-- STORAGES INICIAIS (opcional - dados padrão)
-- ============================================================================
INSERT INTO `sjr_storages` (`storage_name`, `storage_data`) VALUES
('BurguerShot', '{}'),
('Japones', '{}'),
('Ferramentas', '{}'),
('Equipamentos', '{}'),
('Canada', '{}'),
('Bratva', '{}'),
('Milicia', '{}'),
('MotoClub', '{}'),
('Crips', '{}'),
('Turquia', '{}'),
('Hells', '{}'),
('thelost', '{}'),
('Brasil', '{}'),
('b13', '{}'),
('StreetRacing', '{}'),
('Cv', '{}'),
('Vagos', '{}'),
('portugal', '{}'),
('aztecas', '{}'),
('Iluminatis', '{}'),
('Vanilla', '{}'),
('camora', '{}'),
('camoradois', '{}'),
('Tequila', '{}')
ON DUPLICATE KEY UPDATE storage_name = storage_name;

-- ============================================================================
-- STORAGES ADICIONAIS PARA ORGANIZAÇÕES/FACÇÕES
-- ============================================================================
INSERT INTO `sjr_storages` (`storage_name`, `storage_data`) VALUES
('Grota', '{}'),
('Ballas', '{}'),
('Croacia', '{}'),
('argentina', '{}'),
('Mafia', '{}'),
('croacia', '{}'),
('Bennys', '{}'),
('Cartel', '{}'),
('HavanaCustom', '{}'),
('HospitalCopacabana', '{}')
ON DUPLICATE KEY UPDATE storage_name = storage_name;

-- ============================================================================
-- PROCEDURES (opcional - para limpeza automática de logs antigos)
-- ============================================================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS clean_old_craft_logs(IN days_to_keep INT)
BEGIN
    DELETE FROM `sjr_craft_logs` 
    WHERE `timestamp` < DATE_SUB(NOW(), INTERVAL days_to_keep DAY);
END //

CREATE PROCEDURE IF NOT EXISTS clean_old_storage_transactions(IN days_to_keep INT)
BEGIN
    DELETE FROM `sjr_storage_transactions` 
    WHERE `timestamp` < DATE_SUB(NOW(), INTERVAL days_to_keep DAY);
END //

CREATE PROCEDURE IF NOT EXISTS clean_old_route_progress(IN days_to_keep INT)
BEGIN
    DELETE FROM `sjr_route_progress` 
    WHERE `completed_at` IS NOT NULL 
    AND `completed_at` < DATE_SUB(NOW(), INTERVAL days_to_keep DAY);
END //

DELIMITER ;

-- ============================================================================
-- EVENTOS (opcional - para limpeza automática)
-- Descomente se quiser limpeza automática dos logs
-- ============================================================================

-- Evento para limpar logs a cada 30 dias
-- CREATE EVENT IF NOT EXISTS clean_craft_logs_event
-- ON SCHEDULE EVERY 1 MONTH
-- DO
-- CALL clean_old_craft_logs(30);

-- Evento para limpar transações de storage a cada 30 dias
-- CREATE EVENT IF NOT EXISTS clean_storage_transactions_event
-- ON SCHEDULE EVERY 1 MONTH
-- DO
-- CALL clean_old_storage_transactions(30);

-- ============================================================================
-- TRIGGERS (opcional - para logging automático)
-- ============================================================================

-- Trigger para log automático na tabela principal
DELIMITER //

CREATE TRIGGER IF NOT EXISTS after_farmsystem_insert
AFTER INSERT ON `sjr_farmsystem`
FOR EACH ROW
BEGIN
    INSERT INTO `sjr_craft_stats` (`user_id`, `total_items_deposited`)
    VALUES (NEW.user_id, 1)
    ON DUPLICATE KEY UPDATE 
        `total_items_deposited` = `total_items_deposited` + 1;
END //

DELIMITER ;

-- ============================================================================
-- ÍNDICES ADICIONAIS PARA OTIMIZAÇÃO
-- ============================================================================

-- Índices para consultas frequentes
CREATE INDEX IF NOT EXISTS idx_farmsystem_user_day ON `sjr_farmsystem` (`user_id`, `day`);
CREATE INDEX IF NOT EXISTS idx_craft_logs_user_action ON `sjr_craft_logs` (`user_id`, `action`);
CREATE INDEX IF NOT EXISTS idx_storage_transactions_storage ON `sjr_storage_transactions` (`storage_name`, `transaction_type`);

-- ============================================================================
-- VERIFICAÇÃO DAS TABELAS
-- ============================================================================

-- Verificar se todas as tabelas foram criadas corretamente
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    CREATE_TIME
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME LIKE 'sjr_%'
ORDER BY TABLE_NAME;

-- ============================================================================
-- BACKUP SUGESTÃO (opcional - para fazer backup dos dados)
-- ============================================================================

-- CREATE TABLE sjr_farmsystem_backup_20241201 AS SELECT * FROM sjr_farmsystem;
-- CREATE TABLE sjr_craft_logs_backup_20241201 AS SELECT * FROM sjr_craft_logs;

-- ============================================================================
-- FIM DO SCRIPT SQL
-- ============================================================================