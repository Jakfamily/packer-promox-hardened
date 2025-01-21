# Documentation du Playbook de Durcissement

## Introduction

Ce playbook de durcissement est conçu pour appliquer des recommandations de sécurité basées sur des standards internationaux tels que le **CIS** (Center for Internet Security), l'**ANSSI** (Agence Nationale de la Sécurité des Systèmes d'Information), et la directive **NIS2** (Network and Information Systems Directive). Les rôles et tâches dans ce playbook visent à sécuriser les systèmes en conformité avec les meilleures pratiques de cybersécurité.

### Objectifs du playbook :

- Sécuriser l'accès SSH.
- Renforcer la configuration du noyau.
- Mettre en place des mécanismes de surveillance (logs, audits).
- Installer des outils de protection tels que **Fail2ban**, **ClamAV**, etc.
- Appliquer des politiques de gestion des mots de passe.
- Créer des rapports post-déploiement.

## 1. Rôles et Recommandations

### 1.1 Rôle `users`

**Recommandations :**
- **ANSSI R20** : Création d'utilisateurs administrateurs et de groupes sécurisés.
- **CIS 5.2.10** : Utilisation des groupes pour gérer les utilisateurs autorisés à se connecter via SSH.

**Explication :**
Le rôle **`users`** crée des utilisateurs, configure des groupes pour l'accès SSH, et applique des politiques de sécurité pour la gestion des utilisateurs.

### 1.2 Rôle `fail2ban`

**Recommandations :**
- **CIS 6.2.5** : Utilisation de mécanismes de défense contre les tentatives de connexion par force brute.
- **ANSSI R23** : Mise en place de **Fail2ban** pour protéger contre les attaques par force brute.

**Explication :**
Le rôle **`fail2ban`** installe et configure **Fail2ban**, un outil qui protège contre les attaques par force brute en surveillant les logs et en bloquant les adresses IP suspectes.

### 1.3 Rôle `firewall`

**Recommandations :**
- **CIS 1.1.2** : Filtrage des paquets entrants et sortants pour empêcher les connexions non autorisées.
- **ANSSI R15** : Configuration d'un pare-feu pour limiter l'accès aux services.

**Explication :**
Le rôle **`firewall`** configure **UFW** (Uncomplicated Firewall) pour appliquer des règles de filtrage des paquets et sécuriser les ports du serveur.

### 1.4 Rôle `packages`

**Recommandations :**
- **CIS 4.1.2** : Installer uniquement les paquets nécessaires et sécuriser les installations.
- **NIS2** : Assurer la mise à jour des logiciels et des paquets du système.

**Explication :**
Le rôle **`packages`** garantit que seuls les paquets nécessaires sont installés sur le serveur et que ceux-ci sont mis à jour pour éviter les vulnérabilités.

### 1.5 Rôle `ssh-hardening`

**Recommandations :**
- **CIS 5.2.1** : Désactiver l'accès SSH en tant que **root** et utiliser des clés SSH plutôt que des mots de passe.
- **ANSSI R23** : Restreindre les connexions SSH aux utilisateurs autorisés.

**Explication :**
Le rôle **`ssh-hardening`** applique des restrictions sur les connexions SSH en interdisant l'accès **root**, en configurant des clés SSH, et en limitant les utilisateurs autorisés.

### 1.6 Rôle `grub-password`

**Recommandations :**
- **CIS 2.1.1** : Protéger l'accès au menu GRUB avec un mot de passe.
- **ANSSI R3** : Sécuriser l'accès à la configuration du noyau.

**Explication :**
Le rôle **`grub-password`** configure un mot de passe pour empêcher les utilisateurs non autorisés de modifier les paramètres de démarrage dans le menu GRUB.

### 1.7 Rôle `kernel`

**Recommandations :**
- **CIS 3.1** : Configurer les paramètres du noyau pour réduire la surface d'attaque.
- **ANSSI R5** : Appliquer des recommandations sur la gestion des paramètres système.

**Explication :**
Le rôle **`kernel`** applique des paramètres de configuration du noyau pour durcir le système contre certaines attaques.

### 1.8 Rôle `aide`

**Recommandations :**
- **CIS 6.1.1** : Configurer **AIDE** (Advanced Intrusion Detection Environment) pour détecter toute modification des fichiers système.
- **ANSSI R7** : Mise en place d'un système de détection d'intrusions.

**Explication :**
Le rôle **`aide`** installe et configure **AIDE** pour assurer la surveillance et la détection des modifications suspectes des fichiers système.

### 1.9 Rôle `lynis`

**Recommandations :**
- **CIS 6.2.1** : Effectuer des audits réguliers pour vérifier la conformité aux bonnes pratiques de sécurité.
- **NIS2** : Assurer un audit régulier de l'infrastructure.

**Explication :**
Le rôle **`lynis`** exécute des audits de sécurité via **Lynis**, un outil d'audit de sécurité, pour vérifier la conformité aux normes de sécurité.

### 1.10 Rôle `clam-av`

**Recommandations :**
- **CIS 6.2.5** : Mettre en place une solution antivirus comme **ClamAV** pour détecter les malwares.
- **ANSSI R18** : Protection contre les logiciels malveillants.

**Explication :**
Le rôle **`clam-av`** installe et configure **ClamAV**, un antivirus open-source, pour scanner le système à la recherche de malwares.

### 1.11 Rôle `rsyslog`

**Recommandations :**
- **CIS 4.1.1** : Configurer **rsyslog** pour collecter et centraliser les logs du système.
- **ANSSI R13** : Mise en place d'une gestion des logs pour surveiller les activités du système.

**Explication :**
Le rôle **`rsyslog`** configure le service **rsyslog** pour collecter, stocker, et gérer les logs du système, permettant ainsi une surveillance continue.

### 1.12 Rôle `post_deployment_report`

**Recommandations :**
- **CIS 6.3.1** : Générer des rapports de conformité après chaque déploiement.
- **NIS2** : Création de rapports de sécurité post-déploiement.

**Explication :**
Le rôle **`post_deployment_report`** génère un rapport après chaque déploiement, résumant les changements effectués et l'état de la sécurité du système.

## 2. Références aux Standards de Sécurité

### 2.1 **CIS (Center for Internet Security)**
- Le **CIS Benchmark** fournit des lignes directrices de durcissement de système pour renforcer la sécurité du système d'exploitation.
- **Articles applicables** : CIS 1.1.2, CIS 5.2.1, CIS 6.1.1, etc.

### 2.2 **ANSSI (Agence Nationale de la Sécurité des Systèmes d'Information)**
- L'**ANSSI** propose des recommandations pour protéger les systèmes d'information contre les menaces potentielles, avec un accent sur la gestion des utilisateurs, l'audit, la sécurisation des accès, etc.
- **Articles applicables** : ANSSI R20, ANSSI R23, etc.

### 2.3 **NIS2 (Directive européenne sur la sécurité des réseaux et des systèmes d'information)**
- La directive **NIS2** définit des exigences strictes pour la gestion des risques de cybersécurité dans les infrastructures critiques et les services essentiels.
- **Articles applicables** : NIS2, audit, détection d'intrusions, etc.

## Conclusion

Ce playbook implémente les recommandations des principaux standards de sécurité, y compris **CIS**, **ANSSI**, et **NIS2**, pour renforcer la sécurité du serveur. Chaque rôle a été configuré pour répondre spécifiquement à une ou plusieurs exigences de ces standards, garantissant ainsi une couverture complète des meilleures pratiques de durcissement et de sécurité.
