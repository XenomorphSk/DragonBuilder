#!/bin/bash
### BEGIN HEADER INFO
# Title:        Dragon Builder
# Author:       Gabriel S. Ribeiro
# Date:         2024-09-21
# Version:      1.1
# Description:  Script para criar ISO UEFI personalizada com sistema completo
### END HEADER INFO

ISO_OUTPUT="custom_linux_uefi.iso"
WORK_DIR="/tmp/iso_build"
EFI_DIR="$WORK_DIR/EFI/boot"
GRUB_CFG_PATH="$WORK_DIR/boot/grub/grub.cfg"
ROOTFS_PATH="/"  # Atualize o caminho para o sistema de arquivos root completo

# Função para instalar dependências
install_dependencies() {
    echo "Instalando dependências..."
    sudo apt-get install -y grub-efi-amd64-bin mtools xorriso squashfs-tools
}

# Função para configurar EFI
setup_efi_structure() {
    echo "Configurando EFI..."
    mkdir -p "$EFI_DIR"
    sudo cp /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed "$EFI_DIR/bootx64.efi"
}

# Função para copiar arquivos essenciais
setup_filesystem() {
    echo "Copiando arquivos essenciais..."
    mkdir -p "$WORK_DIR/casper"
    mkdir -p "$WORK_DIR/boot/grub"
    
    # Copia kernel e initramfs
    cp /boot/vmlinuz-$(uname -r) "$WORK_DIR/casper/vmlinuz"
    cp /boot/initrd.img-$(uname -r) "$WORK_DIR/casper/initrd.img"

    if [ ! -f "$WORK_DIR/casper/vmlinuz" ] || [ ! -f "$WORK_DIR/casper/initrd.img" ]; then
        echo "Erro: Kernel ou initrd.img não encontrados."
        exit 1
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
    
    # Cria o sistema de arquivos root
    mksquashfs "$ROOTFS_PATH" "$WORK_DIR/casper/filesystem.squashfs" -e boot

    echo "Sistema de arquivos root copiado com sucesso."
}

# Função para criar ISO
create_uefi_iso() {
    echo "Criando a ISO UEFI personalizada..."
    grub-mkrescue -o "$ISO_OUTPUT" "$WORK_DIR" --modules="part_gpt part_msdos fat iso9660"
}

# Função principal
main() {
    install_dependencies
    setup_efi_structure
    setup_filesystem
    copy_rootfs
    create_uefi_iso
}

# Verificação de root e execução
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root."
    exit 1
fi

main
