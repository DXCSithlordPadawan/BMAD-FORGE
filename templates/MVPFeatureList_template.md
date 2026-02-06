---
name: mvp-feature-list-template
description: MVP feature list template for defining and prioritizing minimum viable product features.
role: pm
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the product planning specialist persona for MVP definition"
    keywords_required:
      - "MVP"
      - "features"
    keywords_recommended:
      - "prioritize"
      - "product"
      - "value"
    validation_severity: critical
    examples:
      - "Act as a product planning specialist who defines and prioritizes minimum viable product features to deliver maximum value."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for MVP feature planning"
    keywords_required:
      - "features"
    keywords_recommended:
      - "stories"
      - "requirements"
      - "constraints"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected MVP feature list deliverables"
    keywords_required:
      - "features"
      - "priority"
    keywords_recommended:
      - "criteria"
      - "dependencies"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product"
    required: true
    type: text
    placeholder: "Product Name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  MVP_VERSION:
    description: "MVP version identifier"
    required: false
    type: text
    placeholder: "1.0"
    default: "1.0"

  TARGET_RELEASE:
    description: "Target release timeframe"
    required: false
    type: select
    options:
      - "Q1"
      - "Q2"
      - "Q3"
      - "Q4"
    default: "Q1"
---

## Your Role

Act as a product planning specialist who creates comprehensive MVP feature documentation. You define, describe, and prioritize minimum viable product features to ensure the product delivers maximum value with available resources.

## Input

You expect to receive:
- Product vision and value proposition
- User stories and acceptance criteria
- Resource and timeline constraints
- Stakeholder priorities and requirements
- Technical dependencies and limitations

## Output Requirements

Your output will include:
- Detailed feature descriptions with user stories
- Acceptance criteria for each feature
- Priority classification (High/Medium/Low)
- Dependencies and risk assessments
- ROI analysis and stakeholder considerations

---

# MVP Feature List
Author:Your Name Here

---

## Feature Overview
This section provides a detailed overview of each key feature included in the MVP. The objective is to define every feature's purpose and value clearly and succinctly. This clarity ensures stakeholders understand the function and benefits of each feature. It's imperative for setting the foundation of the product's direction and helping the team focus on essential features.

### Feature Name
Assign an intuitive and descriptive name to each feature. The name should clearly convey the primary function or benefit and be easily understood by all stakeholders, including developers, designers, and end-users. Aim for simplicity and clarity. Avoid ambiguous or overly technical terms that may cause confusion.

### Feature Description
Provide a concise yet comprehensive explanation of what the feature does. Highlight its core functionality and describe how it will enhance the user's experience. Include the problem it solves, its key benefits, and any innovative aspects. This section should make it clear why the feature is essential for the MVP.

### User Story
Include a user story to provide real-world context. This should outline who the user is, what they want to achieve with the feature, and why it is important to them. User stories help to keep features user-centric and ground the development process in real-world use cases. Ensure the story addresses the user's needs and pain points.

### Acceptance Criteria
Specify the acceptance criteria for each feature. These are the conditions that must be met for the feature to be considered complete. Clear acceptance criteria ensure that the feature meets the intended requirements and functions correctly. Acceptance criteria should be measurable and testable, encompassing both functional and non-functional aspects.

### Priority
Classify the feature's priority to determine its inclusion in the MVP. Use categories like High, Medium, or Low to indicate its criticality and how it fits into the overall product strategy. Clearly defined priorities guide resource allocation and help the team stay focused on delivering the most impactful features first.

### Dependencies
List any dependencies that must be resolved for the feature to be developed and implemented. This includes dependencies on other features, resources, or external systems. Identifying dependencies early helps in planning and avoiding bottlenecks, ensuring a smoother development process.

### Risks and Mitigations
Identify any potential risks associated with the feature and outline mitigation strategies. This can include technical challenges, resource constraints, or market uncertainties. Being proactive about risk management helps ensure successful feature delivery.

---

## Priority Level
This section aids in the precise determination of each feature's relative importance, guiding resource allocation and decision-making. Categorizing features by priority ensures that the MVP delivers maximum value with available resources. Prioritization is essential for focusing efforts on the most impactful features, maintaining a balance between immediate needs and long-term goals.

### High Priority
Identify essential features that are crucial for the MVP's success. These features are non-negotiable and must be included to fulfill the primary value proposition of the product. They address critical user needs and deliver significant value. High-priority features should be the primary focus of the development team early on.

### Medium Priority
Highlight features that add substantial value but are not critical for the initial launch. While beneficial, these features can be slated for later iterations if necessary. Prioritize based on available resources and time constraints. Medium priority features should be well-documented to ensure they can be seamlessly integrated in future updates.

### Low Priority
List features that enhance the user experience but are not required for the MVP. These low-priority features can be postponed to future releases, ensuring the focus remains on delivering core value within the MVP timeline. Low-priority features should not distract from the critical path but can be considered for enhancing future versions of the product.

### RoI Analysis
Conduct a thorough Return on Investment (RoI) analysis for each feature. Understanding the expected benefits versus development costs helps in making informed prioritization decisions. This assessment aids in optimizing resource allocation for maximum impact. Make sure to consider both short-term gains and long-term strategic value in your analysis.

### Dependencies
Identify any dependencies that influence the prioritization of features. Dependencies may include other features, team availability, or external factors that impact development timelines and resource requirements. Clear understanding of dependencies helps in realistic planning and execution.

### Stakeholder Input
Gather and incorporate input from all relevant stakeholders. Their perspectives can provide valuable insights into the prioritization process, ensuring that the most impactful features are addressed first. Regularly update and communicate the priority list to stakeholders to maintain alignment and transparency.

---