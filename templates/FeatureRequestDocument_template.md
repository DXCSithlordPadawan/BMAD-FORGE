---
name: feature-request-template
description: Feature request document template for proposing and documenting new product features.
role: pm
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the product planning specialist persona for feature requests"
    keywords_required:
      - "feature"
    keywords_recommended:
      - "documentation"
      - "proposal"
      - "analysis"
    validation_severity: critical
    examples:
      - "Act as a product planning specialist who creates comprehensive feature request documentation with business justification and technical considerations."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for feature request documentation"
    keywords_required:
      - "feature"
    keywords_recommended:
      - "requirements"
      - "goals"
      - "constraints"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected feature request deliverables"
    keywords_required:
      - "feature"
    keywords_recommended:
      - "justification"
      - "impact"
      - "implementation"
    validation_severity: critical

variables:
  FEATURE_NAME:
    description: "Name of the proposed feature"
    required: true
    type: text
    placeholder: "Feature Name"
    help_text: "Enter a descriptive name for the feature"

  AUTHOR_NAME:
    description: "Request author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  PRIORITY:
    description: "Feature priority"
    required: true
    type: select
    options:
      - "Critical"
      - "High"
      - "Medium"
      - "Low"
    default: "Medium"

  EFFORT_ESTIMATE:
    description: "Estimated implementation effort"
    required: false
    type: select
    options:
      - "Small (< 1 week)"
      - "Medium (1-4 weeks)"
      - "Large (1-3 months)"
      - "XL (> 3 months)"
    default: "Medium (1-4 weeks)"
---

## Your Role

Act as a product planning specialist who creates comprehensive feature request documentation. You document feature proposals with business justification, user impact analysis, and technical considerations to enable informed decision-making.

## Input

You expect to receive:
- Feature concept and description
- Business goals and strategic alignment
- Target user segments and their needs
- Technical constraints and dependencies
- Resource and timeline considerations

## Output Requirements

Your output will include:
- Feature overview with name and detailed description
- Business justification including ROI estimation
- User impact analysis with benefits and affected segments
- Technical implementation considerations and risks
- Dependencies and mitigation strategies

---

# Feature Request Document
Author:Your Name Here

---

## Feature Overview
Begin with a comprehensive summary of the proposed feature. This section should clearly define the feature, its specific purpose, and the user problem it aims to address. It sets the stage for the deeper analysis that follows.

### Feature Name
Clearly state the proposed name or title for the feature. The name should be descriptive and succinct, ensuring that stakeholders can instantly grasp its essence and purpose.

### Feature Description
Provide a detailed description of the feature's functionality. Explain how it works, its key components, and how it integrates into the existing product. Highlight the particular user pain points it addresses and the value it adds.

---

## Business Justification
Demonstrate the potential impact of the feature on the business. This section should outline the expected return on investment (ROI), improvements in customer satisfaction or engagement, and alignment with broader business objectives.

### Business Alignment
Describe how this feature supports the company's strategic goals and objectives. Detail its alignment with key performance indicators (KPIs) and how it contributes to long-term business success.

### ROI Estimation
Provide a projected return on investment (ROI) for the feature. Balance development costs against anticipated financial returns or cost savings, and substantiate with relevant data or benchmarks.

---

## User Impact
Identify the user segments that will benefit from this feature and detail the impact it will have on them. Consider changes in user behavior, benefits they will receive, and responses to user needs or requests.

### Affected User Segments
Specify the user groups that will be impacted by this feature. Analyze the size and characteristics of these segments to understand the breadth of its impact.

### User Benefits
Detail the specific advantages this feature offers to users. Explain how it will improve their experience, solve existing problems, or add new value to their interaction with the product.

---

## Technical Considerations
Analyze the technological aspects of implementing the feature. This section should address the complexity of deployment, dependencies, required resources, and potential risks, providing a clear understanding of the technical feasibility.

### Implementation Complexity
Examine the complexity of integrating the feature into the current system. Identify technical challenges, required skills, and technologies necessary for successful implementation.

### Dependencies & Resources
List all dependencies on other teams, features, or systems. Clarify the resources needed, including time, personnel, and technology, to ensure effective execution.

### Risks & Mitigation
Identify potential risks associated with the feature and propose mitigation strategies. This fosters preparedness and resilience in the planning and implementation process.

---
