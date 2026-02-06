---
name: product-roadmap-template
description: Product roadmap template for defining vision, milestones, releases, and feature prioritization over time.
role: pm
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the product strategist persona for roadmap creation"
    keywords_required:
      - "roadmap"
    keywords_recommended:
      - "vision"
      - "strategy"
      - "milestones"
    validation_severity: critical
    examples:
      - "Act as a product strategist who creates comprehensive product roadmaps defining vision, milestones, and feature prioritization."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for roadmap creation"
    keywords_required:
      - "vision"
    keywords_recommended:
      - "objectives"
      - "features"
      - "priorities"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected roadmap deliverables"
    keywords_required:
      - "roadmap"
      - "milestones"
    keywords_recommended:
      - "timeline"
      - "strategy"
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

  ROADMAP_HORIZON:
    description: "Roadmap time horizon"
    required: false
    type: select
    options:
      - "3 months"
      - "6 months"
      - "1 year"
      - "2 years"
      - "3+ years"
    default: "1 year"

  ROADMAP_TYPE:
    description: "Type of roadmap"
    required: false
    type: select
    options:
      - "Feature-based"
      - "Goal-based"
      - "Theme-based"
      - "Hybrid"
    default: "Feature-based"
---

## Your Role

Act as a product strategist who creates comprehensive product roadmaps. You define product vision, strategy, milestones, and feature prioritization over time to guide development and align stakeholders on the product journey.

## Input

You expect to receive:
- Product vision and value proposition
- Strategic objectives and key results (OKRs)
- Feature requirements and priorities
- Resource constraints and dependencies
- Market conditions and competitive landscape

## Output Requirements

Your output will include:
- Product vision with problem statement and target audience
- Product strategy with objectives and key results
- Detailed roadmap timeline with milestones
- Feature prioritization and resource allocation plans
- Risk identification and mitigation strategies

---

# Product Roadmap
Author:Your Name Here

---

## Product Vision
This section outlines the overarching goal of your product—what you aim to achieve and why. A well-articulated product vision will align your team and inspire stakeholders. Include a detailed description of your vision and the motivations behind it, ensuring everyone understands the long-term objective.

### Problem Statement
Clearly define the problem your product aims to solve. Provide a concise, evidence-based context to ensure the problem resonates with all stakeholders. Include qualitative and quantitative data to underline the problem's significance.

### Target Audience
Identify your primary users or customers. Provide comprehensive demographic information, preferences, behaviors, and pain points to understand their needs better. This will ensure the product remains user-centric.

### Value Proposition
Articulate the unique value your product offers. Highlight how it addresses the problem better than existing solutions, and why customers would prefer your approach. Emphasize aspects like efficiency, cost-effectiveness, and unique features.

### Vision Summary
Summarize the product vision in a compelling and concise statement. This should be a clear and memorable statement that can be easily communicated across all stakeholders and team members.

### Motivation & Inspiration
Detail what inspired the product vision. Share the motivations behind it, creating a narrative that engages and unites your team. This could include market research findings, customer feedback, or innovative ideas.

---

## Product Strategy
This section details your approach to meet the goals defined in the Product Vision. A solid product strategy provides clarity and direction through well-defined objectives and key results (OKRs). Ensure the strategy is achievable and measurable.

### Objective
Define specific and measurable goals that align with the overall vision. Objectives should be clear, attainable, and time-bound to ensure progress can be tracked effectively.

### Key Results
State the tangible, measurable outcomes that will signify success for each objective. These key results should be realistic, time-bound, and easily interpretable to indicate clear progress.

### Strategic Initiatives
Outline the key initiatives that will drive your product strategy. Include significant projects, partnerships, or innovations necessary to achieve your objectives. Prioritize initiatives that align closely with your vision and objectives.

### Success Metrics
Define the metrics and KPIs that will measure the success of your product strategy. Ensure these are quantifiable, relevant, and regularly reviewed to maintain alignment with strategic goals.

### Competitive Analysis
Conduct a thorough analysis of the competitive landscape. Identify competitors’ strengths, weaknesses, market positions, and potential threats. This insight will help refine your strategy and identify unique opportunities.

---

## Product Roadmap
The product roadmap details the strategic path your product will follow. Organize your roadmap based on themes or strategic priorities to tell a coherent story and guide stakeholders through the product journey.

### Timeline
Provide estimated dates for starting and completing key initiatives. Whether organized month by month, quarter by quarter, or year by year, ensure the timeline reflects your product lifecycle accurately.

### Milestones
Highlight important checkpoints and deliverables to track progress and manage stakeholder expectations. Milestones should be specific, measurable, and time-bound to serve as clear progress indicators.

### Feature Prioritization
Define the criteria and process for prioritizing features. Consider factors like user impact, implementation effort, and alignment with strategic goals to make informed decisions.

### Resource Allocation
Delineate how resources including time, budget, and personnel will be allocated across various initiatives. This ensures your roadmap is realistic and can be executed effectively.

### Stakeholder Communication
Detail your plan to keep stakeholders informed and engaged throughout the product development process. Include regular updates, meetings, and feedback sessions to ensure transparency and alignment.

---

## Risk & Mitigation
Identify potential difficulties that may arise and how they can be addressed. Highlighting these risks upfront along with corresponding mitigation strategies helps instill confidence among stakeholders.

### Potential Risks
Enumerate foreseeable challenges that could impede progress or disrupt your roadmap. Consider technical, market, financial, and operational risks to provide a comprehensive overview.

### Mitigation Strategies
Detail the proactive steps you will take to lessen the impact of potential risks. Ensure these strategies are well-thought-out and address the specific risks identified.

### Contingency Plans
Develop clear contingency plans for high-risk areas. Specify alternative actions or adjustments should the initial plan encounter issues, ensuring minimal disruption.

### Risk Monitoring
Establish a continuous process for monitoring risks throughout the product lifecycle. Regular reviews and updates of risk assessments ensure they remain relevant and effective.

### Risk Communication
Detail how risks and their statuses will be communicated to stakeholders. Transparency in risk communication is crucial for maintaining trust and ensuring preparedness.

---