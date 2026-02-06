---
name: product-security-assessment-template
description: Product security assessment template for evaluating security risks, vulnerabilities, and compliance requirements.
roles:
  - qa
  - architect
workflow_phase: development
category: security

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the security analyst persona for assessments"
    keywords_required:
      - "security"
    keywords_recommended:
      - "risks"
      - "vulnerabilities"
      - "compliance"
    validation_severity: critical
    examples:
      - "Act as a security analyst who evaluates security risks, identifies vulnerabilities, and provides recommendations for robust product security."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for security assessment"
    keywords_required:
      - "security"
    keywords_recommended:
      - "architecture"
      - "requirements"
      - "compliance"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected security assessment deliverables"
    keywords_required:
      - "security"
      - "risk"
    keywords_recommended:
      - "vulnerabilities"
      - "recommendations"
      - "compliance"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product being assessed"
    required: true
    type: text
    placeholder: "Product Name"

  AUTHOR_NAME:
    description: "Assessment author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  ASSESSMENT_TYPE:
    description: "Type of security assessment"
    required: false
    type: select
    options:
      - "Full Assessment"
      - "Vulnerability Scan"
      - "Penetration Test"
      - "Compliance Audit"
      - "Risk Assessment"
    default: "Full Assessment"

  COMPLIANCE_FRAMEWORKS:
    description: "Applicable compliance frameworks"
    required: false
    type: multiselect
    options:
      - "SOC 2"
      - "ISO 27001"
      - "GDPR"
      - "HIPAA"
      - "PCI DSS"
      - "NIST"
      - "CIS"

  RISK_LEVEL:
    description: "Overall risk classification"
    required: false
    type: select
    options:
      - "Critical"
      - "High"
      - "Medium"
      - "Low"
    default: "Medium"
---

## Your Role

Act as a security analyst who creates comprehensive product security assessments. You evaluate security risks, identify vulnerabilities, assess compliance requirements, and provide recommendations to ensure robust product security.

## Input

You expect to receive:
- Product description and technical specifications
- System architecture and dependencies
- Deployment environment information
- Compliance requirements and regulations
- Known security concerns or past incidents

## Output Requirements

Your output will include:
- Product overview with security-focused technical analysis
- Security posture assessment including data protection and authentication
- Comprehensive risk assessment with threat analysis
- Vulnerability management and incident response plans
- Business continuity and compliance recommendations

---

# Product Security Assessment
Author:Your Name Here

---

## Product Overview
The 'Product Overview' section provides a foundational understanding of the product's functionalities, technological foundation, and operational environment. This comprehensive insight is essential to identify security vulnerabilities unique to the product’s context, dependencies, and user interactions, allowing for a targeted and effective security strategy.

### Product Description
Initiate the security assessment with a clear, comprehensive description of your product. Detail core functionalities, target demographics, and distinguishing features to highlight unique security needs and potential attack vectors. For instance, financial applications demand stringent transaction encryptions, while social media platforms require robust identity protection.

- Provide an overview of the product’s primary use cases.
- Identify unique selling points and market differentiation.
- Specify typical user profiles and their security expectations.
- Highlight industry-specific compliance requirements.
- Describe known security challenges pertinent to the product type.

### Technical Specifications
An in-depth breakdown of the technical architecture is essential. This includes the programming languages, frameworks, hardware requirements, and network configurations. Understanding these elements aids in constructing a security framework that aligns with the product's technological specifics, identifying and addressing weak points proactively.

- Detail the technology stack, including languages, frameworks, and databases.
- Describe hardware and software dependencies.
- Map out network architecture and data flow.
- Highlight integration points and associated security concerns.
- Connect technical details to potential vulnerabilities.

### Key Features
Focus on the product's key features, providing a detailed analysis of their functionalities and how they interact with user data. Each feature may present unique security challenges that need to be addressed. For example, a data export feature might require stringent data protection measures.

- List primary features and their functionalities.
- Detail how each feature handles user data.
- Identify security challenges for key features.
- Suggest mitigation strategies for these challenges.
- Highlight any compliance or legal considerations.

### Dependencies
Analyze third-party services, APIs, and libraries that your product relies on, as each external component introduces specific security considerations. Documenting these dependencies helps in recognizing and mitigating inherited vulnerabilities.

- List all third-party services, APIs, and libraries used.
- Evaluate the security posture of these dependencies.
- Identify critical dependencies and their security implications.
- Document known vulnerabilities in third-party components.
- Suggest strategies to mitigate risks associated with third-party dependencies.

### Deployment Environment
Detail your product’s deployment environment—whether it’s on-premises, cloud-based, or hybrid—as it significantly influences required security measures. For example, cloud deployments often necessitate robust encryption and dynamic access controls.

- Specify the deployment environment (on-premises, cloud, or hybrid).
- Detail relevant security measures for the deployment model.
- Highlight challenges unique to the deployment environment.
- Describe encryption and access control measures.
- Assess deployment’s impact on the overall security posture.

---

## Security Overview
The 'Security Overview' section provides a comprehensive view of the current security posture, outlining strengths, identifying weaknesses, and paving the way for targeted improvements. Understanding where we stand establishes a baseline for developing a strategic path to enhanced security resilience.

### Data Security Measures
Assess current data security protocols, focusing on encryption standards, data integrity checks, and backup processes. Evaluating and enhancing these measures ensures sensitive information is well protected.

- List current encryption methods.
- Assess data integrity verification processes.
- Evaluate backup and recovery system robustness.
- Identify areas for improvement in data security protocols.
- Explore new technologies to enhance data security.

### User Privacy
Detail mechanisms for safeguarding user privacy, such as data anonymization, regulatory compliance, and data use transparency. Strengthening privacy measures not only protects users but also builds trust and credibility.

- Describe data anonymization and pseudonymization techniques.
- Review compliance with privacy laws and regulations.
- Detail transparency practices in data usage policies.
- Assess the effectiveness of current privacy measures.
- Suggest improvements to enhance user privacy.

### System Integrity
Evaluate current measures for maintaining system integrity, such as automated updates, rigorous system checks, and performance monitoring. Strengthening system integrity ensures resilience against unauthorized modifications and operational disruptions.

- Review the update and patch management process.
- Describe system check and validation processes.
- Assess performance monitoring practices.
- Identify vulnerabilities in system integrity measures.
- Suggest enhancements to improve overall system integrity.

### Authentication and Authorization
Discuss the frameworks for authentication and authorization, emphasizing methods for verifying user identities and assigning permissions. Robust techniques like multi-factor authentication (MFA), single sign-on (SSO), and role-based access control (RBAC) are crucial for fortified security.

- Describe current authentication methods (e.g., MFA, SSO).
- Review role-based access control mechanisms.
- Assess strengths and weaknesses of these frameworks.
- Identify potential threats to authentication and authorization.
- Suggest improvements to enhance security.

### Security Auditing and Monitoring
Outline strategies for continuous security monitoring, including regular audits, real-time threat detection, and incident response protocols. Proactive and continuous monitoring is essential for swiftly identifying and mitigating potential threats, maintaining a robust security stance.

- Describe current security auditing practices.
- Detail real-time monitoring tools and techniques.
- Assess the effectiveness of incident response strategies.
- Identify gaps in security monitoring processes.
- Recommend strategies to improve continuous security monitoring.

---

## Risk Assessment
The 'Risk Assessment' section identifies, evaluates, and mitigates risks that could compromise the product's security. A thorough risk assessment allows us to handle various challenges effectively, ensuring the product remains secure and reliable in different scenarios.

### Threat Analysis
Conduct a detailed analysis of potential threats, both internal and external. Cataloging these threats helps in understanding the risk landscape and is crucial for developing comprehensive security strategies.

- Identify potential internal and external threats.
- Prioritize threats based on severity and likelihood.
- Assess the impact of these threats on the product.
- Evaluate past incidents and learnings.
- Develop strategies to address identified threats.

### Risk Mitigation
Develop strategies to minimize the impact of risks, ranging from technical safeguards like firewalls and anti-malware tools to operational procedures such as incident response plans and regular training. Effective risk mitigation reduces the likelihood and severity of security incidents.

- Identify technical and operational risk mitigation strategies.
- List safeguards like firewalls, anti-malware tools, and intrusion detection systems.
- Detail procedural strategies, including incident response and training.
- Assess the effectiveness of current mitigation practices.
- Recommend improvements to strengthen risk mitigation efforts.

### Incident Response Plan
Establish comprehensive incident response protocols detailing immediate actions, communication channels, and recovery steps in the event of a security breach. A well-structured incident response plan minimizes damage and restores normal operations swiftly.

- Document immediate steps to take post-incident.
- Describe communication channels for incident reporting.
- Outline recovery steps to restore normal operations.
- Assess the current incident response plan for gaps.
- Recommend enhancements to improve response effectiveness.

### Vulnerability Management
Detail processes for identifying, evaluating, and addressing vulnerabilities. Regular scanning, timely patch management, and system updates are critical to maintaining security and closing potential attack vectors promptly.

- Outline the process for regular vulnerability scanning.
- Describe patch management practices.
- Evaluate effectiveness of current vulnerability management.
- Identify common vulnerabilities and remediation strategies.
- Suggest improvements to enhance vulnerability management.

### Business Continuity Planning
Strategize to ensure uninterrupted business operations during and after security incidents. This includes disaster recovery planning, backup systems, and robust communication protocols, ensuring resilience and operational stability.

- Describe disaster recovery planning processes.
- Review robustness of backup systems.
- Outline communication protocols for continuity planning.
- Evaluate existing business continuity measures.
- Recommend strategies to strengthen business continuity plans.

---
