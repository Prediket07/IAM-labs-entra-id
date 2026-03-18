# Identity & Access Management Labs (Microsoft Entra ID)

## Overview

This repository showcases a structured progression of hands-on labs focused on **Identity and Access Management (IAM)** using Microsoft Entra ID (Azure AD), Azure Automation, and Microsoft Graph.

These labs simulate real-world IAM responsibilities including:

- User provisioning and lifecycle management
- Role-Based Access Control (RBAC)
- Multi-Factor Authentication (MFA)
- Conditional Access policies
- Privileged access management
- Audit logging and monitoring
- Automated identity lifecycle workflows (JML)

---

## Lab Breakdown

### 🔹 Core IAM Foundations

- **Lab0_Tenant-Users**  
  User creation, tenant structure, and identity basics

- **Lab1_RBAC-Least-Privilege**  
  Role-Based Access Control and least privilege principles

- **Lab2_MFA-Security-Defaults**  
  MFA implementation and security defaults

- **Lab4_Enterprise-App-Access**  
  Application access and enterprise app integration

---

### 🔹 IAM Lifecycle & Monitoring

- **Lab5_Joiner-Mover-Leaver**  
  Manual identity lifecycle management (JML)

- **Lab6_Monitoring-Audit**  
  Logging, monitoring, and audit trails

- **Lab7_Conditional-Access**  
  Conditional Access policies and enforcement

- **Lab8_Privileged-Access**  
  Privileged Identity Management (PIM) concepts

---

### 🔹 Automation & Advanced IAM

- **Lab9_Automated-Offboarding**  
  Automated user offboarding using Azure Automation and Microsoft Graph  
  - Disable accounts  
  - Revoke sessions  
  - Remove licenses  
  - Remove group memberships  

- **Lab10_JML-Automation** ⭐  
  Full **Joiner-Mover-Leaver (JML) automation system**  
  - Automated onboarding (user creation + group assignment)  
  - Automated role changes (department + access updates)  
  - Automated offboarding (secure account deprovisioning)  
  - Webhook-triggered workflows simulating HR systems  

---

## Technologies Used

- Microsoft Entra ID (Azure AD)
- Azure Automation Runbooks
- Microsoft Graph PowerShell SDK
- Managed Identity
- Webhooks
- PowerShell

---

## Key Skills Demonstrated

- Identity lifecycle management (JML)
- Role-Based Access Control (RBAC)
- Least privilege access design
- Automation of user provisioning and deprovisioning
- Secure offboarding practices
- Cloud identity security
- Access governance and policy enforcement

---

## Architecture (Lab10 Highlight)

HR System → Webhook → Azure Automation → Microsoft Graph → Entra ID

---

## Purpose

This repository was built to develop hands-on IAM engineering skills and demonstrate practical experience in:

- Automating identity workflows
- Securing user access across the lifecycle
- Implementing enterprise IAM concepts in a cloud environment

---

## Author

**Jairus Ross**  
Aspiring IAM Engineer | Cybersecurity | Microsoft Entra ID | Azure Automation
