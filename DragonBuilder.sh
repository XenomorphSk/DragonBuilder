#!/bin/bash
### BEGIN HEADER INFO
# Title:        Dragon Builder
# Author:       Gabriel S. Ribeiro
# Date:         2024-09-21
# Version:      1.2
# Description:  Script para criar ISO UEFI personalizada com sistema completo, otimizado
### END HEADER INFO

# Variáveis
ISO_OUTPUT="custom_linux_uefi.iso"
WORK_DIR="/tmp/iso_build"
EFI_DIR="$WORK_DIR/EFI/boot"
GRUB_CFG_PATH="$WORK_DIR/boot/grub/grub.cfg"
ROOTFS_PATH="/"  # Atualize o caminho para o sistema de arquivos root completo
MEM_LIMIT="4096M"  # Limite de memória para mksquashfs

# Função para instalar dependências
install_dependencies() {
    echo "Instalando dependências..."
    if ! sudo apt-get update; then
        echo "Erro ao atualizar repositórios."
        exit 1
    fi
    if ! sudo apt-get install -y grub-efi-amd64-bin mtools xorriso squashfs-tools; then
        echo "Erro ao instalar dependências."
        exit 1
    fi
}

# Função para configurar EFI
setup_efi_structure() {
    echo "Configurando EFI..."
    if ! sudo mkdir -p "$EFI_DIR"; then
        echo "Erro ao criar diretório EFI."
        exit 1
    fi
    if ! sudo cp /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed "$EFI_DIR/bootx64.efi"; then
        echo "Erro ao copiar o arquivo grubx64.efi para EFI."
        exit 1
    fi
}

# Função para copiar arquivos essenciais
setup_filesystem() {
    echo "Copiando arquivos essenciais..."
    if ! sudo mkdir -p "$WORK_DIR/casper" "$WORK_DIR/boot/grub"; then
        echo "Erro ao criar diretórios necessários."
        exit 1
    fi
    
    # Copia kernel e initramfs
    if ! sudo cp /boot/vmlinuz-$(uname -r) "$WORK_DIR/casper/vmlinuz"; then
        echo "Erro ao copiar vmlinuz."
        exit 1
    fi
    if ! sudo cp /boot/initrd.img-$(uname -r) "$WORK_DIR/casper/initrd.img"; then
        echo "Erro ao copiar initrd.img."
        exit 1
    fi
}

# Função para verificar espaço em disco e memória
check_resources() {
    echo "Verificando espaço em disco e memória..."
    
    # Verifica espaço disponível no diretório de trabalho
    DISK_AVAILABLE=$(df "$WORK_DIR" | awk 'NR==2 {print $4}')
    
    # Verifica se o espaço é maior que 10GB (requisito mínimo aproximado)
    if [ "$DISK_AVAILABLE" -lt 10485760 ]; then
        echo "Erro: Espaço insuficiente em disco (requer pelo menos 10GB)."
        exit 1
    fi

    # Verifica memória disponível
    MEM_AVAILABLE=$(free -m | awk 'NR==2 {print $7}')
    
    # Verifica se a memória disponível é maior que 4GB
    if [ "$MEM_AVAILABLE" -lt 4096 ]; then
        echo "Aviso: Memória disponível é baixa (<4GB). Isso pode afetar o processo de criação do filesystem."
    fi
}

# Função para criar o sistema de arquivos root
copy_rootfs() {
    echo "Criando sistema de arquivos root (squashfs)..."
    
    # Verifique se o diretório root está correto
    if [ ! -d "$ROOTFS_PATH" ]; then
        echo "Erro: O diretório root ($ROOTFS_PATH) não foi encontrado!"
        exit 1
    fi
    
    # Remove o arquivo existente, se presente
    if [ -f "$WORK_DIR/casper/filesystem.squashfs" ]; then
        if ! sudo rm "$WORK_DIR/casper/filesystem.squashfs"; then
            echo "Erro ao remover arquivo squashfs existente."
            exit 1
        fi
    fi

    # Cria o sistema de arquivos root, excluindo diretórios indesejados e atributos estendidos (-no-xattrs)
    if ! sudo mksquashfs "$ROOTFS_PATH" "$WORK_DIR/casper/filesystem.squashfs" \
        -e boot -e /proc/* -e /run/* -e /sys/* -e /dev/* -e /tmp/* -e /mnt/* \
        -no-xattrs -no-duplicates -noappend -mem "$MEM_LIMIT" -v; then
        echo "Erro ao criar o sistema de arquivos root."
        exit 1
    fi

    echo "Sistema de arquivos root copiado com sucesso."
}

# Função para criar ISO
create_uefi_iso() {
    echo "Criando a ISO UEFI personalizada..."
    if ! sudo grub-mkrescue -o "$ISO_OUTPUT" "$WORK_DIR" --modules="part_gpt part_msdos fat iso9660"; then
        echo "Erro ao criar a ISO."
        exit 1
    fi
    echo "ISO criada com sucesso: $ISO_OUTPUT"
}

# Função para exibir mensagens
msg() {
    echo -e "\033[1;32m$1\033[0m"
}

# Função para corrigir problemas do Firefox
fix_firefox() {
    msg "Iniciando correções para o Firefox..."

    # Encerrar o Firefox, se estiver em execução
    msg "Encerrando o Firefox, se estiver em execução..."
    pkill firefox

    # Limpar cache do Firefox
    msg "Limpando o cache do Firefox..."
    rm -rf ~/.cache/mozilla/firefox/*/cache2
    rm -rf ~/.mozilla/firefox/*/sessionstore-backups

    # Verificar permissões e corrigir, se necessário
    msg "Verificando permissões..."
    for dir in ~/.cache/mozilla/firefox ~/.mozilla/firefox; do
        if [ -d "$dir" ]; then
            sudo chown -R "$USER:$USER" "$dir"
            msg "Propriedade do diretório $dir alterada para $USER"
        else
            msg "Diretório $dir não encontrado."
        fi
    done

    # Recriar diretórios do cache
    msg "Recriando diretórios de cache do Firefox..."
    mkdir -p ~/.cache/mozilla/firefox/*/cache2
    mkdir -p ~/.mozilla/firefox/*/sessionstore-backups

    # Suprimir erros do /proc ao limpar o Firefox
    msg "Limpando arquivos do /proc relacionados ao Firefox..."
    rm /proc/*/task/*/maps 2>/dev/null
    rm /proc/*/task/*/smaps 2>/dev/null
    rm /proc/*/task/*/smaps_rollup 2>/dev/null
    rm /proc/*/task/*/stack 2>/dev/null
    rm /proc/*/task/*/stat 2>/dev/null
    rm /proc/*/task/*/statm 2>/dev/null
    rm /proc/*/task/*/status 2>/dev/null
    rm /proc/*/task/*/syscall 2>/dev/null
    rm /proc/*/task/*/uid_map 2>/dev/null
    rm /proc/*/task/*/wchan 2>/dev/null
    rm /proc/*/*timerslack_ns 2>/dev/null
    rm /proc/*/uid_map 2>/dev/null
    rm /proc/*/wchan 2>/dev/null

    # Informar que o processo de correção foi concluído
    msg "Correções do Firefox concluídas."
}


# Função principal
main() {
    install_dependencies
    check_resources
    setup_efi_structure
    setup_filesystem
    copy_rootfs
    create_uefi_iso
    fix_firefox  # Chama a função de correção do Firefox
}

# Verificação de root e execução
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root."
    exit 1
fi

# Criação do diretório de trabalho
if ! sudo mkdir -p "$WORK_DIR"; then
    echo "Erro ao criar o diretório de trabalho."
    exit 1
fi

# Executa a função principal
main
