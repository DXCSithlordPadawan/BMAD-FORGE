---
name: design-spec-template
description: Design specification template for documenting product design, user personas, and UI/UX requirements.
roles:
  - developer
  - architect
workflow_phase: development
category: design

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the design specification author persona and responsibilities"
    keywords_required:
      - "design"
      - "specification"
    keywords_recommended:
      - "documentation"
      - "requirements"
      - "personas"
    validation_severity: critical
    examples:
      - "Act as a design specification author who creates comprehensive product design documentation including user personas, requirements, and milestones."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify what inputs are needed for the design specification"
    keywords_required:
      - "requirements"
    keywords_recommended:
      - "product"
      - "design"
      - "constraints"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected design specification deliverables"
    keywords_required:
      - "requirements"
    keywords_recommended:
      - "milestones"
      - "personas"
      - "functional"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product being designed"
    required: true
    type: text
    placeholder: "Product Name"
    help_text: "Enter the product name for the design specification"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  DESIGN_PHASE:
    description: "Current design phase"
    required: false
    type: select
    options:
      - "Conceptual"
      - "Preliminary"
      - "Detailed"
      - "Final"
    default: "Preliminary"

  PLATFORM:
    description: "Target platform for the design"
    required: false
    type: multiselect
    options:
      - "Web"
      - "Mobile iOS"
      - "Mobile Android"
      - "Desktop"
      - "API"
---

## Your Role

Act as a design specification author who creates comprehensive product design documentation. You document product overviews, user personas, design requirements, and development milestones to guide the design and development process.

## Input

You expect to receive:
- Product concept and value proposition
- Target user descriptions and demographics
- Functional and non-functional requirements
- Design constraints and technical specifications
- Project timeline and milestone expectations

## Output Requirements

Your output will include:
- Product overview with description and user personas
- Detailed functional and non-functional requirements
- Development milestones with timeline estimates
- Risk identification and mitigation strategies
- Clear acceptance criteria for design completion

---

# Design Spec
Author:Your Name Here

---

## Product Overview
Initiate your design specification with an insightful overview of the product. The content of this section should vividly illustrate what the product is, why it exists, and the exact problem it aims to solve. Clearly articulate the product's value proposition. This sets the stage for all stakeholders to understand the foundational vision of the product.

### Product Description
Delve deeper into the product by outlining its core functionalities, the intricacies of its user interface, and its notable features. Describe its components, attributes, and how it operates to provide a solid understanding of what sets your product apart. Reveal how it interacts with other systems and its overall role in the broader system. Being meticulous in this section is crucial, as it impacts subsequent stages of product design and development and sets stakeholder expectations.

### User Persona
Give a comprehensive depiction of your target users. Include demographic data, behavioral attributes, motivations, and the pain points your product intends to address. Understanding these personas will assist in crafting a design that is user-centric, relatable, and effectively tackles the challenges faced by the users. Remember to devote time to research and define each persona as the success of your product depends on it. Ensure personas are detailed and based on real data to facilitate accurate design decisions.

---

## Design Requirements
Detailed design requirements are pivotal to the product's success. These are derived from user needs and business objectives and serve as the guiding principles for development. They cover every aspect of your product design, from the structure to the feature set, ensuring alignment with overall business strategies.

### Functional Requirements
Outline the product's functionality, specifying the abilities it should have to meet user needs and business goals. List all the features the product should possess, from front-end user interface components to back-end processes. It's paramount to clearly define functionality as it shapes the user experience and directly impacts usability and satisfaction. Prioritize these requirements based on user impact and business value.

### Non-Functional Requirements
Specify the qualities your product should possess beyond its functionalities, such as system performance, security standards, and usability aspects. These ensure the product’s robustness, resilience, and longevity and help maintain a competitive edge even if they are not directly tied to user needs. It's essential to define non-functional requirements alongside functional ones, as they greatly affect the overall user experience. Make sure these requirements are measurable to assess their impact accurately.

---

## Milestones and Timeline
Plan and articulate the entire project's critical stages, aligning them with timeframes. This set timeline aids in steering the team in the right direction, managing stakeholder expectations, and ensuring project progression at a consistent pace. Regularly review and adjust the timeline to reflect current project status and external dependencies.

### Development Milestones
Define the critical stages in the development process, specifying the expected outputs at each stage and target completion dates. This roadmap facilitates team alignment, clarity about roles, and aids in monitoring the project's progress against the target deadlines. Ensure milestones are SMART (Specific, Measurable, Achievable, Relevant, Time-bound) to enhance focus and accountability.

### Risks and Mitigation
Identify potential risks that could hamper the project progress and outline strategic mitigation plans. This proactive approach fosters team preparedness, helps simplify complex situations, and ensures smooth project execution even in the face of unforeseen circumstances. Ensure risks are continuously monitored and mitigation plans are updated as the project evolves.

---