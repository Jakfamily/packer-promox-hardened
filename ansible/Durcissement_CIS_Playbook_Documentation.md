
# Documentation Complète pour le Playbook "Durcissement CIS avec gestion des utilisateurs et services"

## Introduction

Ce playbook Ansible a pour objectif de renforcer la sécurité d'un système en appliquant des pratiques de durcissement conformes aux recommandations du CIS (Center for Internet Security). Chaque tâche a été pensée pour améliorer la sécurité, la gestion des utilisateurs, les services critiques, et les logs, tout en permettant une vérification et une correction manuelle en cas d'erreurs.

---

## Table des Matières

1. [Création de l'utilisateur administrateur et configuration sudo](#1-création-de-lutilisateur-administrateur-et-configuration-sudo)
2. [Installation des packages nécessaires](#2-installation-des-packages-nécessaires)
3. [Gestion des mots de passe](#3-gestion-des-mots-de-passe)
4. [Configuration du pare-feu UFW](#4-configuration-du-pare-feu-ufw)
5. [Configuration de Fail2Ban](#5-configuration-de-fail2ban)
6. [Rotation des logs](#6-rotation-des-logs)
7. [Durcissement des paramètres kernel](#7-durcissement-des-paramètres-kernel)
8. [Configuration PAM](#8-configuration-pam)
9. [Configuration d'AIDE](#9-configuration-daide)
10. [Audit de sécurité avec Lynis](#10-audit-de-sécurité-avec-lynis)
11. [Monitoring post-déploiement](#11-monitoring-post-déploiement)
12. [Sécurisation des services SSH](#12-sécurisation-des-services-ssh)
13. [Gestion centralisée des journaux avec rsyslog](#13-gestion-centralisée-des-journaux-avec-rsyslog)
14. [Tests manuels et résolution des erreurs](#tests-manuels-et-résolution-des-erreurs)

---

## 1. Création de l'utilisateur administrateur et configuration sudo

### Objectif

Créer un utilisateur administrateur sécurisé, vérifier que le groupe sudo existe et configurer des politiques renforcées pour sudo.

### Tâches

1. **Création de l'utilisateur `debian`** :
   - Ajoute un utilisateur administrateur avec un mot de passe sécurisé et accès sudo.
2. **Vérification du groupe sudo** :
   - Vérifie que le groupe sudo existe sur le système.
3. **Configuration sudo pour exiger un mot de passe** :
   - Modifie `/etc/sudoers` pour demander un mot de passe avant d'exécuter des commandes avec sudo.
4. **Renforcement avec `requiretty`** :
   - Ajoute une exigence pour que sudo ne soit exécuté que depuis un terminal interactif.
5. **Restriction des commandes sudo au groupe sudo** :
   - Limite les commandes autorisées uniquement aux utilisateurs du groupe sudo.

### Tests manuels

- Vérifiez que l'utilisateur a été créé : `id debian`.
- Assurez-vous que le mot de passe est requis : `sudo -l`.
- Vérifiez `/etc/sudoers` : `sudo visudo`.

### Résolution des erreurs

- Si l'utilisateur n'est pas créé, assurez-vous que les droits d'Ansible sont corrects (`become: yes`).
- Si `sudo` ne fonctionne pas, validez la syntaxe avec `visudo`.

---

## 2. Installation des packages nécessaires

### Objectif

Installer les outils nécessaires pour le durcissement, la gestion des logs, la surveillance, et les audits.

### Tâches

- Installe des packages comme `libpam-pwquality`, `fail2ban`, `ufw`, `lynis`, `aide`, etc.

### Tests manuels

- Vérifiez les versions des packages :

  ```bash
  dpkg -l | grep -E "libpam|fail2ban|ufw|lynis|aide"
  ```

### Résolution des erreurs

- Si un package n'est pas installé, vérifiez les dépôts avec `sudo apt update`.

---

## 3. Gestion des mots de passe

### Objectif

Renforcer la sécurité des mots de passe et des politiques d'expiration.

### Tâches

1. **Politique de complexité des mots de passe** :
   - Modifie `/etc/security/pwquality.conf` pour exiger des mots de passe complexes.
2. **Expiration des mots de passe** :
   - Configure les limites d'expiration dans `/etc/login.defs`.

### Tests manuels

- Testez la politique avec `passwd debian`.
- Vérifiez la configuration :

  ```bash
  cat /etc/security/pwquality.conf
  cat /etc/login.defs
  ```

### Résolution des erreurs

- Si les politiques ne s'appliquent pas, redémarrez les services PAM : `sudo systemctl restart sshd`.

---

## 4. Configuration du pare-feu UFW

### Objectif

Activer le pare-feu UFW et autoriser uniquement les connexions SSH.

### Tâches

1. **Activation d'UFW** :
   - Active le pare-feu avec une politique par défaut restrictive.
2. **Autorisation des connexions SSH** :
   - Ouvre le port 22 pour les connexions SSH.

### Tests manuels

- Vérifiez l'état d'UFW : `sudo ufw status`.

### Résolution des erreurs

- Si UFW ne s'active pas, vérifiez `/var/log/ufw.log` pour des erreurs spécifiques.

---

## 5. Configuration de Fail2Ban

### Objectif

Protéger les services SSH contre les attaques par force brute.

### Tâches

- Configure `/etc/fail2ban/jail.local` pour surveiller les tentatives de connexion SSH.

### Tests manuels

- Vérifiez l'état de Fail2Ban : `sudo fail2ban-client status`.
- Testez un ban en simulant des échecs SSH.

### Résolution des erreurs

- Si Fail2Ban ne fonctionne pas, vérifiez `/var/log/fail2ban.log`.

---

## 6. Rotation des logs

### Objectif

Mettre en place une rotation régulière des journaux.

### Tâches

- Configure `/etc/logrotate.d/auth` pour gérer la rotation des logs SSH.

### Tests manuels

- Testez la rotation : `sudo logrotate -f /etc/logrotate.conf`.

### Résolution des erreurs

- Si la rotation échoue, vérifiez les permissions sur `/var/log/`.

---

## 7. Durcissement des paramètres kernel

### Objectif

Configurer des paramètres sysctl pour améliorer la sécurité réseau.

### Tâches

- Modifie les paramètres dans `/etc/sysctl.conf` pour désactiver ICMP ping et activer TCP SYN cookies.

### Tests manuels

- Vérifiez les valeurs appliquées : `sysctl -a | grep "icmp_echo_ignore_all"`.

### Résolution des erreurs

- Si les paramètres ne s'appliquent pas, relancez `sudo sysctl -p`.

---

## 8. Configuration PAM

### Objectif

Limiter les tentatives de connexion.

### Tâches

- Configure `pam_faillock` pour bloquer après 5 échecs.

### Tests manuels

- Testez des connexions SSH avec des mots de passe incorrects.

### Résolution des erreurs

- Vérifiez `/var/log/auth.log` pour des informations sur les échecs.

---

## 9. Configuration d'AIDE

### Objectif

Surveiller les fichiers critiques.

### Tâches

1. Initialisation de la base de données AIDE.
2. Configuration des chemins à surveiller.

### Tests manuels

- Lancer une vérification : `sudo aide --check`.

### Résolution des erreurs

- Si AIDE échoue, vérifiez la syntaxe dans `/etc/aide/aide.conf`.

---

## 10. Audit de sécurité avec Lynis

### Objectif

Effectuer un audit complet du système.

### Tâches

- Lancer Lynis et sauvegarder les rapports générés.

### Tests manuels

- Exécutez Lynis manuellement : `sudo lynis audit system`.

---

## 11. Monitoring post-déploiement

### Objectif

Surveiller les services critiques après déploiement.

### Tâches

- Vérifiez les journaux SSH, Fail2Ban, et UFW régulièrement.

---

## 12. Sécurisation des services SSH

### Objectif

Restreindre et sécuriser les connexions SSH.

### Tâches

1. Désactiver `PermitRootLogin`.
2. Limiter les utilisateurs autorisés.

### Tests manuels

- Testez la connexion SSH avec un utilisateur non autorisé.

---

<!--

## 13. Gestion centralisée des journaux avec rsyslog

### Objectif

Configurer rsyslog pour la gestion centralisée des journaux.

### Tâches

- Configure rsyslog pour envoyer les logs à un serveur centralisé.

### Tests manuels

- Vérifiez la configuration de rsyslog : `cat /etc/rsyslog.conf`.

### Résolution des erreurs

- Si rsyslog ne fonctionne pas, vérifiez les permissions et la configuration du serveur de journaux.

---

## Tests manuels et résolution des erreurs

- En cas de problèmes, vérifiez les journaux pertinents (`/var/log/auth.log`, `/var/log/syslog`, etc.).
- Assurez-vous que les services nécessaires sont actifs : `sudo systemctl status sshd`, `sudo systemctl status ufw`, etc.

-->

---
