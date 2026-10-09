# AstroBuddy — Project Proposal

---

## a. Project Title

**AstroBuddy: An AI-Powered Astronomy Companion for Context-Aware Sky Exploration, Learning, and Observation Planning**

*Alternate short title:* AstroBuddy — Explore. Learn. Observe.

---

## b. Problem Statement

Amateur stargazing has a low entry barrier in principle — the sky is free and visible to everyone — but in practice, beginners abandon the hobby quickly. The reasons are structural rather than motivational:

1. **Identification without understanding.** Existing star-map applications answer *"what is that object?"* but stop there. A user learns a label ("Betelgeuse") without learning why it matters, what it is, or how to observe it well. Recognition does not become knowledge.

2. **Fragmented observation planning.** Deciding whether tonight is worth going outside requires combining at least five independent data sources: a weather forecast, cloud-cover maps, moon phase and moonrise/moonset times, the object's altitude above the horizon during dark hours, and local light-pollution levels. No mainstream consumer application fuses these into a single verdict. Users must manually cross-reference apps and interpret raw data they do not yet understand.

3. **Equipment mismatch and early failure.** Applications routinely recommend deep-sky objects (galaxies, faint nebulae) to users who own no equipment at all. The user goes outside, sees nothing, and concludes the hobby is not for them. Visibility is presented as a binary rather than as a function of aperture, sky darkness, and object magnitude.

4. **Static, one-size-fits-all content.** Information pages are written at a fixed reading level. Content appropriate for a school student is unhelpful for an experienced observer, and vice versa. There is no adaptation to the user's demonstrated knowledge.

5. **No learning structure.** There is no guided progression from "find the Moon" to "resolve the Cassini Division." Users are handed a full sky and left to self-direct, which strongly favours those who already know what they are doing.

6. **Generic AI assistance.** Where AI features exist, they are general-purpose chatbots with no awareness of the user's location, time, weather, equipment, or what is actually above their horizon. The answer to *"what should I look at tonight?"* is generic when it should be specific.

**Problem statement (formal):** *There is no single consumer application that unifies accurate real-time celestial visualization, situation-aware AI explanation, equipment-appropriate recommendations, and multi-factor observability forecasting into a coherent experience that both identifies celestial objects and teaches the user to understand and successfully observe them.*

---

## c. Motivation and Need for the Project

### Motivation

* **Growing public interest, high drop-off.** Public interest in space is rising, driven by high-visibility missions (Artemis, JWST, Chandrayaan, commercial launch programmes) and widely reported events such as eclipses and comet apparitions. Interest converts to sustained hobby participation at a low rate, largely because the first few observation attempts fail.
* **Increasing light pollution.** Sky brightness is increasing globally at roughly 7–10% per year in populated areas. This makes naive recommendations ("look for the Andromeda Galaxy") actively misleading for urban users, and makes equipment- and sky-quality-aware filtering more valuable than it was a decade ago.
* **Educational relevance.** Astronomy appears in school and undergraduate curricula, but classroom teaching is largely diagrammatic and disconnected from the actual sky. A tool that connects textbook concepts to the sky visible from the learner's own location has direct pedagogical value.
* **Enabling technology has matured.** High-accuracy ephemeris computation, free global weather APIs, satellite-derived light-pollution datasets, and large language models capable of adaptive explanation are all now accessible to a small development team. The combination — not any individual component — is what is newly feasible.

### Need for the Project

| Stakeholder | Unmet need |
|---|---|
| Beginners | Being told what is realistically visible *with their eyes, tonight, from their city* |
| Students | Structured, progressive learning tied to real observation rather than diagrams |
| Educators | A classroom-usable tool that demonstrates the live sky and answers follow-up questions |
| Amateur astronomers | A single observability verdict instead of five browser tabs |
| Astrophotographers | Planning windows based on altitude, moon interference, and forecast cloud cover |
| Families | Age-appropriate explanations without dumbing down the underlying science |

### Objectives

**Primary objectives**

1. **O1 — Accurate real-time sky rendering.** Implement an interactive night-sky map computing positions of stars, planets, the Moon, and deep-sky objects from the user's GPS location, device orientation, and system time, with positional accuracy sufficient for naked-eye and small-telescope use (target: < 1 arcminute for solar-system bodies, catalog-limited for stars).
2. **O2 — Time-travel simulation.** Allow the sky to be simulated for any arbitrary past or future date and time, supporting event planning and historical reconstruction.
3. **O3 — Rich object information.** Provide, for each catalogued object, scientific classification, distance, apparent magnitude, parent constellation, visibility data, historical and mythological context, and practical observation tips, presented at multiple depth levels.
4. **O4 — Context-aware AI assistant.** Build a conversational assistant that receives the user's current sky state, location, equipment, and skill level as context, so that answers are specific rather than generic, and grounded in a curated astronomy knowledge base to limit hallucination.
5. **O5 — Composite observability scoring.** Design and implement an algorithm that fuses cloud cover, moon phase and separation, object altitude, atmospheric conditions, and local sky brightness into a single interpretable score with a plain-language explanation.
6. **O6 — Equipment-aware filtering.** Classify every object by the equipment tier required to observe it (naked eye → binoculars → beginner telescope → advanced) *as a function of local sky darkness*, not as a fixed global label.
7. **O7 — Personalized learning journey.** Deliver an adaptive sequence of observation challenges and concepts that responds to the user's completed observations, current sky availability, and demonstrated knowledge.
8. **O8 — News and events feed.** Aggregate curated space news and upcoming celestial events (eclipses, meteor showers, conjunctions, oppositions) relevant to the user's location.

**Secondary objectives**

9. **O9 — Offline capability.** Ship the core star catalog and ephemeris computation on-device so the sky map functions without network access, which is the common case at dark-sky observing sites.
10. **O10 — Performance.** Maintain a smooth interactive frame rate (target 60 fps) while rendering tens of thousands of catalog objects on mid-range mobile hardware.
11. **O11 — Accessibility and inclusivity.** Support red-light night vision mode, scalable typography, screen-reader labelling, and an architecture ready for multi-language content.

---

## d. Proposed Solution and Methodology

### d.1 Proposed Solution

AstroBuddy is proposed as a **cross-platform mobile application (Flutter/Dart)** backed by a lightweight cloud service layer. It is organised as seven cooperating subsystems:

| # | Subsystem | Responsibility |
|---|---|---|
| S1 | **Astronomy Engine** | Ephemeris computation, coordinate transforms, rise/set/transit times, catalog queries. Runs fully on-device. |
| S2 | **Sky Renderer** | Real-time projection and drawing of the celestial sphere; sensor-driven orientation; gesture and time-scrub controls. |
| S3 | **Knowledge Base** | Curated, structured content per object (science, history, mythology, observation tips) at three depth tiers. |
| S4 | **AI Assistant** | Retrieval-augmented conversational layer that is injected with live sky context before answering. |
| S5 | **Observability Engine** | Fuses weather, moon, altitude, and light-pollution data into a scored, explained recommendation and an optimal observing window. |
| S6 | **Learning Engine** | Maintains a user knowledge/progress model and selects the next challenge from what is actually observable. |
| S7 | **News & Events Service** | Aggregates, deduplicates, and ranks space news and location-relevant celestial events. |

**Central design decision — the Context Bus.** Rather than treating the AI assistant as an isolated chat feature, the application maintains a live *observation context* object (location, timestamp, objects currently above horizon with altitudes, moon phase and illumination, weather forecast, sky brightness estimate, user's equipment and skill level, recent activity). This object is passed to S4, S5, and S6 alike. It is the mechanism that turns three separate features into one coherent product, and it is the core architectural contribution of the project.

#### Observability scoring model

The composite score is computed as a weighted product of normalised sub-scores, so that any single disqualifying factor (total cloud cover, object below horizon) correctly drives the result to zero — an additive model would not:

```
Observability = W_cloud · f_cloud(cloud%)
              × W_alt   · f_alt(altitude, atmospheric extinction)
              × W_moon  · f_moon(illumination, angular separation, object type)
              × W_sky   · f_sky(Bortle class, object surface brightness)
              × W_atm   · f_atm(humidity, seeing proxy, transparency)
```

Each sub-score is retained and surfaced individually, so the application can explain *why* a night scores poorly ("The object is only 12° above the horizon before midnight, and a 91%-illuminated Moon sits 23° away") rather than emitting an opaque number. This explainability requirement is deliberate and pedagogical: the user should learn the reasoning, not just the verdict.

#### Equipment-tier classification

Rather than a static per-object label, the required equipment tier is computed as a function of the object's apparent magnitude (or surface brightness for extended objects) and the user's local sky brightness, using standard limiting-magnitude relations for the unaided eye and for a given aperture. A galaxy that is naked-eye visible from a Bortle 2 site is correctly reported as requiring a telescope from a Bortle 8 city.

### d.2 Methodology

**Development model: Iterative and Incremental (Agile, 2-week sprints).** The astronomy engine has a hard correctness requirement and is validated against reference data; the surrounding features are user-facing and benefit from iteration. Each sprint produces a demonstrable increment.

**Phase plan**

| Phase | Duration | Focus | Exit criterion |
|---|---|---|---|
| **P0 — Research & Design** | Weeks 1–3 | Literature and competitor study, algorithm selection, catalog sourcing and licensing, system design, UI wireframes | Signed-off architecture and data-source list |
| **P1 — Astronomy Core** | Weeks 4–8 | Ephemeris and coordinate math, catalog ingestion into on-device DB, rise/set/transit computation, unit tests against reference ephemerides | Positional error within tolerance vs. reference data |
| **P2 — Sky Map & Object Pages** | Weeks 9–14 | Renderer, projection, sensor fusion, gestures, time travel, object detail pages, knowledge base population | 60 fps with full catalog; object pages complete for Messier + planets |
| **P3 — Observability & Weather** | Weeks 15–18 | Weather/light-pollution integration, scoring model, optimal-window computation, equipment filter | Scored recommendations with per-factor explanations |
| **P4 — AI Assistant** | Weeks 19–22 | Knowledge-base embedding and retrieval, context injection, prompt design, level adaptation, caching and cost control | Grounded answers with sky-specific context; latency budget met |
| **P5 — Learning & News** | Weeks 23–26 | Progress model, challenge selection, achievements, news aggregation and event calendar | Adaptive challenge sequence functioning end-to-end |
| **P6 — Hardening & Evaluation** | Weeks 27–30 | Offline mode, accessibility, performance tuning, field testing, user study, documentation | Evaluation report complete |

**Verification and validation strategy**

* **Astronomical accuracy:** positions cross-checked against JPL Horizons and published almanac values across a sampled date range; automated regression tests fail the build on drift beyond tolerance.
* **AI quality:** a fixed benchmark set of astronomy questions scored for factual accuracy, level-appropriateness, and use of live context; hallucination rate tracked as an explicit metric.
* **Observability model:** predictions logged against user-reported actual observing outcomes; the model is calibrated from this feedback.
* **Usability:** task-based testing with participants drawn from each target segment (student, beginner, experienced amateur), measuring time-to-first-successful-observation.
* **Performance:** frame timing and memory profiling on low-, mid-, and high-tier devices.

**Field evaluation.** Because the product's real claim is "you will successfully see something," the headline evaluation metric is the *success rate of recommended observations* reported by a test cohort over a multi-week period, compared against a control using a conventional star-map app.

---

## e. Technology Stack

### Programming Languages

| Language | Use |
|---|---|
| **Dart** | Application logic, UI, on-device astronomy engine |
| **Python** | Backend services, AI orchestration, data pipelines, catalog preprocessing |
| **SQL** | Catalog and user-data queries (SQLite on-device, PostgreSQL server-side) |
| **C/C++ (via FFI)** | Optional — high-precision ephemeris library binding |
| **GLSL** | Optional — shader-based star field rendering for performance |

### Frameworks and Libraries

| Layer | Choice | Justification |
|---|---|---|
| Mobile framework | **Flutter 3.x** | Single codebase for Android and iOS; `CustomPainter`/Impeller gives direct control over the rendering pipeline, which a sky map needs; strong existing familiarity |
| State management | **Riverpod** (or BLoC) | Compile-safe dependency injection; suits the shared Context Bus pattern |
| Local database | **Drift** (SQLite) or **Isar** | Indexed queries over ~120k catalog rows; supports the offline requirement |
| Rendering | Flutter `CustomPainter` + `dart:ui`, with `flutter_gpu`/shaders if profiling requires | Avoids a heavyweight 3D engine for what is fundamentally a 2D projection of a sphere |
| Sensors | `geolocator`, `sensors_plus`, `flutter_compass` | GPS fix, accelerometer/magnetometer/gyroscope fusion for orientation |
| Ephemeris | `sweph` (Swiss Ephemeris FFI binding) **or** a Dart implementation of Meeus/VSOP87 + ELP-2000 | Swiss Ephemeris gives high accuracy at the cost of a licence consideration and binary size; a Meeus implementation is lighter, fully controlled, and sufficient for visual astronomy. **Recommendation: implement Meeus/VSOP87 in Dart** — it is accurate to well under an arcminute for visual use, has no licensing constraint, and is itself a defensible technical contribution |
| Backend | **FastAPI** (Python) | Async, minimal, first-class typing; ideal for a thin AI-orchestration and aggregation layer |
| Auth & sync | **Firebase Authentication** + **Cloud Firestore** | Removes auth boilerplate; Firestore suits sparse per-user progress documents |
| Vector search | **pgvector** (PostgreSQL) or **ChromaDB** | Retrieval over the astronomy knowledge base for the RAG pipeline |
| Caching | **Redis** | Weather responses, news feed, and repeated AI answers — the primary cost-control mechanism |

### Databases

| Store | Location | Contents |
|---|---|---|
| **SQLite (Drift/Isar)** | On-device | Star catalog, DSO catalog, constellation lines and boundaries, cached knowledge-base content, observation log — enables offline mode |
| **PostgreSQL (+ pgvector)** | Server | Canonical knowledge base, embeddings, curated news, event calendar |
| **Cloud Firestore** | Server | User profiles, equipment, progress, achievements, preferences |
| **Redis** | Server | Ephemeral caches (weather, news, AI responses) |

### External APIs and Data Sources

| Purpose | Source | Notes |
|---|---|---|
| Star catalog | **HYG Database** (Hipparcos + Yale BSC + Gliese) | ~120k stars with position, magnitude, spectral class; permissively licensed |
| Deep-sky objects | **OpenNGC**, Messier catalog | NGC/IC objects with type, magnitude, size |
| Constellations | **IAU** boundaries + Stellarium line data | Standard 88 constellations |
| Ephemeris reference | **JPL Horizons** | Validation only, not runtime — keeps the app offline-capable |
| Weather | **Open-Meteo** (primary), OpenWeatherMap (fallback) | Open-Meteo is free, key-less, and exposes cloud cover at multiple altitudes — unusually well suited to astronomy |
| Light pollution | **VIIRS / World Atlas of Artificial Night Sky Brightness** | Preprocessed into a coarse lookup grid shipped on-device |
| Space news | **Spaceflight News API v4**, NASA APIs (APOD, NeoWs), ESA/ISRO feeds | Aggregated and deduplicated server-side |
| AI | **Claude API** or equivalent LLM, with RAG grounding | Server-mediated so keys are never shipped in the client |

### Tools

Git + GitHub · GitHub Actions / Codemagic (CI/CD) · Figma (UI design) · Firebase Crashlytics & Analytics · Postman · Flutter DevTools · Docker (backend) · `flutter_test` / `integration_test` / `pytest` · Sentry · draw.io or Mermaid (diagrams)

---

## f. Expected Deliverables

### Software deliverables

| # | Deliverable | Description |
|---|---|---|
| D1 | **AstroBuddy mobile application** | Working Android and iOS builds with all core features implemented |
| D2 | **Dart Astronomy Engine** | Reusable, tested module for ephemeris and coordinate computation — publishable as an independent open-source package |
| D3 | **Curated astronomy knowledge base** | Structured, multi-tier content covering planets, the Moon, bright stars, 88 constellations, and the Messier catalog |
| D4 | **Observability Scoring Engine** | Documented, calibrated, explainable multi-factor scoring implementation |
| D5 | **Backend services** | Containerised FastAPI service for AI orchestration, news aggregation, and content delivery |
| D6 | **Offline data bundle** | Compressed on-device catalog and light-pollution grid |
| D7 | **Admin/content pipeline** | Scripts for catalog ingestion, content validation, and embedding generation |

### Documentation deliverables

| # | Deliverable |
|---|---|
| D8 | Software Requirements Specification (SRS) |
| D9 | System Design Document — architecture, module, sequence, ER, and data-flow diagrams |
| D10 | Literature Survey and Comparative Analysis report |
| D11 | Test plan and test report, including astronomical accuracy validation results |
| D12 | User manual and in-app onboarding content |
| D13 | Final project report and presentation |
| D14 | Evaluation study report — usability results and observation-success-rate comparison |
| D15 | Optional: research paper draft on the context-aware observability model |

### Measurable success criteria

* Solar-system object positional error < 1 arcminute versus JPL Horizons across the tested date range
* Sustained ≥ 55 fps on mid-tier hardware with the full catalog rendered
* Core sky map fully functional with no network connectivity
* AI assistant factual accuracy ≥ 90% on the benchmark question set
* Recommended-observation success rate measurably higher than the control app in field testing
* SUS usability score ≥ 75 across all three tested user segments

---

## g. Literature Survey / Existing Solutions

### g.1 Existing applications

| Application | Strengths | Limitations relative to AstroBuddy |
|---|---|---|
| **Stellarium / Stellarium Mobile** | Highly accurate, very large catalogs, open source, mature | Simulation-first, not observation-first. No weather integration, no observability verdict, no AI, no learning path. Assumes the user already knows what to look for. |
| **SkySafari** | Excellent depth, telescope control, strong planning tools for experts | Steep learning curve, paid tiers, expert-oriented. No adaptive explanation; no equipment-aware guidance for beginners. |
| **Star Walk 2 / Sky Tonight** | Polished visuals, strong beginner appeal, AR mode | Content is static and shallow; weather awareness is minimal; no structured learning progression; recommendations are not conditioned on local sky quality. |
| **SkyView Lite** | Simple, immediate AR identification | Identification only. Very limited educational depth; no planning capability. |
| **Google Sky Map** (open source, effectively unmaintained) | Free, lightweight, historically influential | Feature-frozen; no weather, no AI, no learning, ageing codebase. |
| **NASA App** | Authoritative mission news, imagery | Not a sky map; no personal observation planning. |
| **Clear Outside / Astrospheric** | Genuinely astronomy-specific weather forecasting — the best-in-class weather tools | Weather only. No sky map, no object information, no learning. The user must mentally join this to a separate star-map app. |
| **Telescopius** | Strong web-based observation planning and target lists for astrophotographers | Web-first, expert-oriented, no mobile live sky map, no AI tutoring. |
| **PhotoPills** | Excellent planning for astrophotography composition | Photography-specific; not an astronomy learning or identification tool. |
| **Light Pollution Map** | Accurate VIIRS-derived sky-brightness data | A data source, not an application; requires interpretation by the user. |

### g.2 Identified market gap

Plotting the landscape on two axes — *educational depth* versus *observation-planning capability* — reveals a clear empty quadrant:

* Stellarium and SkySafari occupy **high accuracy, low guidance**.
* Star Walk and SkyView occupy **high polish, low depth**.
* Clear Outside and Astrospheric occupy **high planning, zero astronomy content**.
* **No application occupies high educational depth *and* high observation-planning capability with beginner-appropriate guidance.**

Every existing product solves one slice. The user is expected to perform the integration manually — and the manual integration step is precisely where beginners drop out.

### g.3 Relevant academic and technical literature

| Area | Reference basis | Relevance |
|---|---|---|
| Positional astronomy algorithms | Meeus, *Astronomical Algorithms* (2nd ed.); Bretagnon & Francou, VSOP87; Chapront-Touzé & Chapront, ELP-2000 | Foundational algorithms for the on-device ephemeris engine |
| Standards | IAU coordinate frames, precession/nutation models; IERS conventions | Correct frame transformations and time scales (UTC/UT1/TT) |
| Sky brightness | Falchi et al., *The New World Atlas of Artificial Night Sky Brightness* (2016); Kyba et al. on globally increasing sky brightness | Basis for the Bortle-class and limiting-magnitude modelling |
| Visual limiting magnitude | Schaefer, "Telescopic Limiting Magnitudes" (PASP, 1990); Bortle scale | Underpins equipment-tier classification |
| Atmospheric extinction | Standard extinction-coefficient models as a function of airmass | Altitude sub-score in the observability model |
| AR in astronomy education | Studies on AR/mobile sky applications reporting improved spatial understanding and engagement versus diagram-based teaching | Justifies the sensor-driven live sky approach pedagogically |
| Adaptive learning | Knowledge-tracing and spaced-repetition literature | Basis for the learning-progression model |
| Retrieval-augmented generation | Lewis et al., RAG (2020) and successors | Method for grounding the AI assistant and reducing hallucination |
| Plate solving / image identification | Astrometry.net (Lang et al., 2010) | Reference approach for the proposed future camera-recognition feature |

### g.4 Summary of the gap

Existing work has solved the individual components — accurate ephemerides are a solved problem, weather APIs are commoditised, sky-brightness data is public, and LLM grounding techniques are established. **What has not been done is the integration**: a single context model that makes the AI assistant, the recommendation engine, and the learning system all aware of the same live observing situation. That integration is what AstroBuddy proposes.

---

## h. Innovation and Unique Contribution

### h.1 Primary innovations

**1. Context-Aware AI Assistant (not a general chatbot).**
The distinguishing property is not that the application contains an LLM — it is *what the LLM is told*. Before every query, the assistant receives the live observation context: the user's coordinates, local sidereal time, the set of objects currently above the horizon with their altitudes, moon phase and illumination, the current weather forecast, local sky brightness, the user's declared equipment, and their demonstrated knowledge level. Consequently "What should I look at tonight?" returns *"Saturn is at 47° in the southeast and rises higher until 1:20 AM — with your 8×42 binoculars you'll see it as a distinct oval rather than a point, which is the classic first step before a telescope"*, rather than a generic list of bright objects. To the best of the survey conducted, no existing consumer astronomy application performs this context injection.

**2. Composite, explainable Observability Score.**
The multiplicative fusion of cloud cover, altitude/extinction, moon interference, sky brightness, and atmospheric conditions into a single 0–100 verdict — with every contributing factor surfaced in plain language — replaces a five-app manual workflow. Explainability is a design requirement rather than a nicety: the score doubles as a teaching mechanism, since the user learns *why* altitude and moon separation matter by repeatedly seeing them affect the result.

**3. Sky-quality-relative equipment classification.**
Required-equipment tiers are computed from apparent/surface magnitude against the user's actual local limiting magnitude, so the same object is classified differently for a Bortle 2 rural user and a Bortle 8 urban user. This directly addresses the primary cause of beginner failure — attempting targets that are physically invisible from where they are standing.

**4. Observability-driven adaptive learning.**
The learning engine selects the next challenge from the intersection of *what the user is ready to learn*, *what their equipment supports*, and *what is actually observable in the next few nights*. A challenge is never issued for an object below the horizon or behind forecast cloud. Existing gamified astronomy features are calendar- or curriculum-driven; conditioning progression on live sky state is, to the survey's knowledge, novel.

**5. The Context Bus architecture.**
A single shared observation-context model consumed by the AI, planner, and learning engine is the structural reason the features cohere rather than sitting side by side. This is the project's main reusable software-engineering contribution and is independently documentable.

**6. Level-adaptive content delivery.**
Object information is authored at three depth tiers and selected by the user's tracked knowledge level, so a single content base serves a school student and an experienced amateur without either encountering the other's version.

### h.2 Secondary contributions

* An **open-source Dart astronomy engine** (VSOP87/Meeus-based) — a genuine gap in the Dart/Flutter ecosystem, useful beyond this project.
* A **fully offline-capable** architecture, correctly matching the real usage context (dark-sky sites have poor connectivity) — a requirement most competitors handle badly.
* A **calibration dataset** linking predicted observability to user-reported observing outcomes, enabling empirical refinement of the scoring model.

### h.3 Comparative positioning

| Capability | Stellarium | SkySafari | Star Walk 2 | Clear Outside | **AstroBuddy** |
|---|---|---|---|---|---|
| Accurate real-time sky map | ✔ | ✔ | ✔ | ✘ | ✔ |
| Time travel | ✔ | ✔ | ✔ | ✘ | ✔ |
| Deep educational content | Partial | Partial | ✘ | ✘ | ✔ |
| Weather integration | ✘ | Partial | Partial | ✔ | ✔ |
| Composite observability score | ✘ | ✘ | ✘ | Partial | ✔ |
| Sky-quality-aware equipment filter | ✘ | ✘ | ✘ | ✘ | ✔ |
| Context-aware AI assistant | ✘ | ✘ | ✘ | ✘ | ✔ |
| Adaptive learning progression | ✘ | ✘ | ✘ | ✘ | ✔ |
| Full offline operation | ✔ | ✔ | Partial | ✘ | ✔ |

### h.4 Honest statement of novelty

The individual technologies used here are established: ephemeris computation is centuries old, weather APIs are commodity infrastructure, and RAG is a standard technique. **The novelty claim is integration and conditioning, not invention.** Specifically: (i) injecting live sky state into an LLM so that astronomy assistance becomes situationally specific; (ii) fusing five observing variables into one explainable verdict; (iii) making equipment recommendations relative to local sky brightness; and (iv) driving a learning curriculum from real-time observability. Each is a modest step individually; together they close the gap identified in §g.2, and none is offered by any surveyed competitor.

---

## Appendix — Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Ephemeris implementation errors | High — undermines the entire product | Automated regression tests against JPL Horizons from Phase 1 onward; accuracy gate in CI |
| Rendering performance with full catalog | High | Spatial indexing (quadtree) with magnitude-based level-of-detail culling; profile on low-tier hardware early |
| Sensor/compass inaccuracy | Medium — misaligned AR view | Kalman-filtered sensor fusion; user-facing manual calibration; graceful degradation to manual pan mode |
| LLM API cost at scale | Medium | Aggressive caching of common questions; smaller model for routine queries; strict token budgets |
| AI hallucination on scientific facts | High — reputational | Strict RAG grounding to the curated knowledge base; benchmark accuracy gate; explicit refusal path for out-of-scope questions |
| Knowledge-base authoring effort underestimated | Medium — this is the most commonly underestimated task | Prioritise planets + Messier + 88 constellations for v1; treat wider catalog coverage as post-v1 |
| Catalog and ephemeris licensing | Medium | Prefer permissive sources (HYG, OpenNGC); avoid Swiss Ephemeris if its licence terms conflict with distribution plans |
| Weather API accuracy for cloud cover | Medium | Multi-source comparison; present forecast confidence honestly rather than as certainty |
| Scope creep across seven subsystems | High | Fixed phase exit criteria; AR, camera recognition, telescope control, and community features are explicitly out of scope for v1 |

---

## Appendix — Future Scope

Camera-based object recognition via on-device plate solving · full AR sky overlay · observation journal with photo logging · community observation sharing · telescope control (ASCOM/INDI, GoTo alignment) · AI-generated post-session summaries · achievement and badge gamification · multi-language content · tablet and desktop clients · classroom/educator mode with shared sessions · astrophotography planning (exposure and framing calculators).
