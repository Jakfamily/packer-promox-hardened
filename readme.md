# **Infrastructure Automatisée avec Cloud-Init, Packer, et Ansible**

## **Description**

Ce projet met en place une infrastructure automatisée utilisant des outils tels que **Cloud-Init**, **Packer**, et **Ansible**. L'objectif est de simplifier et sécuriser le déploiement de machines virtuelles tout en appliquant des configurations avancées pour le durcissement des systèmes.

## **Structure du Projet**

```plaintext
.
├── ansible/
│   └── hardened.yml      # Playbook Ansible pour le durcissement des systèmes
├── cloud-init/
│   ├── cloud.cfg         # Configuration Cloud-Init pour les VMs
│   ├── preseed.cfg       # Fichier Preseed pour l'installation automatisée de Debian
├── debian.pkr.hcl        # Fichier de configuration Packer pour créer l'image Debian
├── secrets.pkrvars.hcl   # Variables sensibles pour Packer (ajouté au .gitignore)
├── .gitignore            # Liste des fichiers et dossiers à ignorer par Git
```

---

## **Fonctionnalités**

1. **Cloud-Init :**
   - Création automatique des utilisateurs avec clé SSH.
   - Configuration réseau (DHCP par défaut).
   - Mise à jour et mise à niveau des paquets lors du premier démarrage.

2. **Packer :**
   - Automatisation de la création de templates Debian avec Preseed et Cloud-Init.
   - Gestion des secrets via un fichier de variables.

3. **Ansible :**
   - Playbook pour appliquer des règles de sécurité (hardening) :
     - Désactivation des services inutiles.
     - Configuration des permissions et des règles de pare-feu.

---

## **Prérequis**

- **Proxmox VE** pour la gestion des machines virtuelles.
- **Terraform** pour orchestrer le déploiement (si nécessaire).
- **Packer** pour la création de templates d'images.
- **Ansible** pour l'application des configurations.

---

## **Installation et Utilisation**

### 1. **Configuration de l'environnement**

- Installez les outils nécessaires :
  - [Packer](https://www.packer.io/)
  - [Ansible](https://www.ansible.com/)
- Configurez votre fichier `.gitignore` pour protéger les données sensibles :

  ```plaintext
  secrets.pkrvars.hcl
  ```

### 2. **Création d'une image avec Packer**

- Lancez la commande suivante pour créer une image Debian personnalisée :

  ```bash
  packer build -var-file=secrets.pkrvars.hcl debian.pkr.hcl
  ```

### 3. **Déploiement de la VM**

- Clonez le template sur Proxmox et configurez la VM pour utiliser **Cloud-Init**.

### 4. **Application des configurations via Ansible (en cours de devellopement)**

- Exécutez le playbook pour appliquer les règles de durcissement :

  ```bash
  ansible-playbook ansible/hardened.yml
  ```

---

## **Améliorations Futures**

- Intégration complète avec **Terraform** pour orchestrer le déploiement sur Proxmox.
- Ajout de tests automatisés pour valider les configurations.
- Exploration de nouveaux outils comme **NixOS** ou **Kubernetes**.

---

## **Contributeurs**

- **[Faria Jean-Baptiste](https://www.linkedin.com/in/faria-jean-baptiste/)** – Créateur du projet.

---

## **Licence**

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus d'informations.
