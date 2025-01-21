# **Infrastructure Automatisée avec Cloud-Init, Packer, et Ansible**

## **Description**

Ce projet propose une solution complète pour la création et la configuration de machines virtuelles (« VMs ») en utilisant **Cloud-Init**, **Packer**, et **Ansible**. L’objectif est de garantir un déploiement rapide, sécurisé et standardisé, tout en intégrant des mesures avancées de durcissement des systèmes.

---

## **Structure du Projet**

```bash
.
├── ansible/
│   ├── hardened.yml      # Playbook Ansible pour le durcissement des systèmes
│   ├── roles/            # Rôles Ansible pour des configurations spécifiques
├── cloud-init/
│   ├── cloud.cfg         # Configuration Cloud-Init pour les VMs
│   ├── preseed.cfg       # Fichier Preseed pour l'installation automatisée de Debian
├── debian.pkr.hcl        # Fichier de configuration Packer pour créer l'image Debian
├── secrets.pkrvars.hcl   # Variables sensibles pour Packer (non inclus dans le dépôt Git)
├── .gitignore            # Liste des fichiers et dossiers à ignorer par Git
├── readme.md             # Documentation du projet
```

---

## **Fonctionnalités**

### **Cloud-Init**

- Création automatique des utilisateurs avec authentification par clé SSH.
- Configuration réseau (DHCP par défaut).
- Mise à jour et mise à niveau des paquets lors du premier démarrage.

### **Packer**

- Automatisation de la création de templates Debian personnalisés.
- Utilisation d’un fichier Preseed pour configurer Debian durant l’installation.
- Gestion des secrets via un fichier de variables.

### **Ansible**

- Application de règles de durcissement (« hardening ») :
  - Désactivation des services inutiles.
  - Renforcement des permissions systèmes.
  - Configuration de la journalisation (rsyslog).
  - Gestion des règles de pare-feu.

---

## **Prérequis**

- **Proxmox VE** pour la gestion des machines virtuelles.
- **Terraform** pour l’orchestration du déploiement (en option).
- **Packer** pour créer des images personnalisées.
- **Ansible** pour appliquer des configurations de durcissement.

---

## **Installation et Utilisation**

### 1. **Configuration de l’environnement**

- Installez les outils suivants :
  - [Packer](https://www.packer.io/)
  - [Ansible](https://www.ansible.com/)

- Assurez-vous que votre fichier `.gitignore` inclut les éléments sensibles :

  ```plaintext
  secrets.pkrvars.hcl
  ```

### 2. **Création d’une image avec Packer**

- Générez une image Debian personnalisée avec la commande suivante :

  ```bash
  packer build -var-file=secrets.pkrvars.hcl debian.pkr.hcl
  ```

### 3. **Déploiement de la VM**

- Importez le template généré dans Proxmox.
- Configurez la VM pour utiliser **Cloud-Init**.

### 4. **Application des configurations via Ansible**

- Exécutez le playbook pour appliquer les règles de durcissement :

  ```bash
  ansible-playbook ansible/hardened.yml
  ```

---

## **Améliorations Futures**

- Intégration complète avec **Terraform** pour orchestrer le déploiement de bout en bout.
- Ajout de tests automatisés pour valider les configurations appliquées.
- Documentation plus détaillée sur les modules Ansible personnalisés.

---

## **Contributeur**

- **[Faria Jean-Baptiste](https://www.linkedin.com/in/faria-jean-baptiste/)** – Créateur du projet.

---

## **Licence**

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus d'informations.
