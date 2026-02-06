---
name: customer-journey-map-template
description: Customer journey map template for visualizing and analyzing customer experiences across touchpoints.
roles:
  - pm
  - analyst
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the customer experience analyst persona"
    keywords_required:
      - "journey"
      - "customer"
    keywords_recommended:
      - "experience"
      - "touchpoints"
      - "analyze"
    validation_severity: critical
    examples:
      - "Act as a customer experience analyst who creates detailed customer journey maps visualizing experiences across all touchpoints."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for journey mapping"
    keywords_required:
      - "customer"
    keywords_recommended:
      - "persona"
      - "touchpoints"
      - "feedback"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected journey map deliverables"
    keywords_required:
      - "journey"
    keywords_recommended:
      - "stages"
      - "pain points"
      - "recommendations"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Product or service name"
    required: true
    type: text
    placeholder: "Product/Service Name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  PERSONA_NAME:
    description: "Primary customer persona name"
    required: true
    type: text
    placeholder: "Persona Name"
    help_text: "Name of the customer persona being mapped"

  JOURNEY_TYPE:
    description: "Type of customer journey"
    required: false
    type: select
    options:
      - "End-to-End"
      - "Onboarding"
      - "Purchase"
      - "Support"
      - "Renewal"
    default: "End-to-End"
---

## Your Role

Act as a customer experience analyst who creates detailed customer journey maps. You visualize and analyze customer experiences across all touchpoints to identify opportunities for improvement and optimization.

## Input

You expect to receive:
- Customer persona descriptions and demographics
- Product or service touchpoint information
- Customer feedback and behavioral data
- Business goals and success metrics
- Current pain points and opportunities

## Output Requirements

Your output will include:
- Detailed customer persona profiles with demographics and behaviors
- Complete journey stage documentation (awareness through advocacy)
- Identified pain points, unmet needs, and innovation areas
- Actionable improvement recommendations
- Implementation action plan with timelines and resources

---

# Customer Journey Map
Author:Your Name Here

---

## Customer Persona
This section develops a detailed profile of the primary customer for whom you are optimizing the journey. It includes demographic details, behavioral patterns, needs, and goals. A deep understanding of customer personas is essential to ensure the journey map remains customer-centric. Multiple customer personas may be created, each with an individual journey map.

### Demographics
Capture basic demographic information such as age, gender, occupation, location, and income level. These details provide a foundational understanding of your customer persona, helping you segment and target effectively.

### Behavior
Examine the behavioral patterns of your customer persona, including buying habits, brand preferences, and digital behavior. Understanding these behaviors allows you to predict future actions and tailor your marketing and engagement strategies.

### Needs and Goals
Identify and articulate the needs and goals of your customer persona. Understand why they are using your product or service and what they aim to achieve, which provides direction for product development and customer support.

### Challenges
List the challenges and pain points your customer persona faces. Knowing their obstacles helps prioritize features and solutions that alleviate these issues.

### Preferred Communication Channels
Determine which communication channels your customer persona prefers and frequently uses. This ensures that your engagement strategies are aligned with their preferences and habits.

---

## Customer Journey Stages
This section delineates the different stages of the customer's journey, which typically include awareness, consideration, decision, retention, and advocacy. Each stage should capture customer actions, feelings, touchpoints, and channels used, providing a comprehensive overview of the journey.

### Awareness Stage
Detail the customer’s actions, emotions, touchpoints, and channels in the awareness stage. This stage represents when they first discover your product or service.

### Consideration Stage
Outline the customer’s actions, emotions, touchpoints, and channels in the consideration stage. This is when they compare your product or service against alternatives.

### Decision Stage
Describe the customer’s actions, emotions, touchpoints, and channels in the decision stage. This stage involves making the final purchase decision.

### Retention Stage
Explain the customer’s actions, emotions, touchpoints, and channels in the retention stage. This stage is about continued engagement and usage of your product or service.

### Advocacy Stage
Illustrate the customer’s actions, emotions, touchpoints, and channels in the advocacy stage. This is when they actively promote your product or service to others, often through reviews or word-of-mouth.

---

## Opportunities for Improvement
Identify and document opportunities for improvement discovered during the journey mapping process. This should include pain points, unmet needs, and potential areas for innovation, which will inform future product enhancements and strategic initiatives.

### Pain Points
Identify and prioritize specific pain points that customers encounter throughout their journey. Addressing these pain points can lead to significant improvements in customer satisfaction and loyalty.

### Unmet Needs
Recognize and list needs that are currently not addressed by your product or service. Meeting these needs can open up new opportunities for differentiation and growth.

### Innovation Areas
Pinpoint areas where introducing new features, services, or processes could enhance the customer journey. Innovation is critical to staying competitive and meeting evolving customer expectations.

### Efficiency Improvements
Identify areas where processes or systems can be made more efficient. Streamlined operations can enhance the customer experience and reduce costs.

### Customer Feedback Integration
Describe how customer feedback will be systematically collected and integrated into your improvement process. Regular feedback loops ensure that the product evolves in line with customer needs.

---

## Action Plan
Develop a detailed action plan based on insights gathered from the journey map. This plan should include new initiatives, pilot programs, and product improvements aimed at enhancing the customer experience and achieving strategic goals.

### New Initiatives
Detail new initiatives designed to address insights and opportunities uncovered through the customer journey mapping process. These initiatives should be actionable and aligned with overall business goals.

### Pilot Programs
Describe pilot programs intended to test new ideas or improvements on a small scale before executing a full-scale rollout. Pilot programs allow for testing and iteration to ensure effectiveness.

### Product Improvements
List specific product improvements aimed at enhancing the customer experience. These should be concrete changes that address identified pain points and unmet needs.

### Timeline and Milestones
Outline a timeline for implementing new initiatives and product improvements. Set clear milestones to track progress and ensure accountability.

### Resource Allocation
Detail the resources—both human and financial—required to execute the action plan. Proper resource allocation is critical to successful implementation.

---