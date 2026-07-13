# Day 1 Schedule - DevOps 2-Day Course (OrderFlow-Lite)

**Total instructional time:** 8.0 hrs (6 modules) + breaks/lunch = full training day

| Time | Duration | Module | OrderFlow-Lite tie-in |
|---|---|---|---|
| 09:00 – 10:00 | 1.0 hr | **1. DevOps Transformation** | Generic — maturity/DORA exercise, not repo-specific |
| 10:00 – 11:00 | 1.0 hr | **2. CI/CD Design and Git** | Design the branching model actually used later (`main` + `capstone-seeded-failure`) |
| 11:00 – 11:15 | 0.25 hr | *Break* | |
| 11:15 – 13:15 | 2.0 hrs | **3. Jenkins Continuous Integration** | Build the `Install & Unit Test` + reporting stages of the real Jenkinsfile |
| 13:15 – 14:00 | 0.75 hr | *Lunch* | |
| 14:00 – 15:30 | 1.5 hrs | **4. Docker Fundamentals and Image Security** | Build the actual multi-stage Dockerfile, run Trivy against the real seeded CVE (`jest-junit` 16.0.0 / `uuid` advisory — see `TRAINING_SEEDS.md`) |
| 15:30 – 15:45 | 0.25 hr | *Break* | |
| 15:45 – 17:45 | 2.0 hrs | **5. Kubernetes Fundamentals and Local Deployment** | Deploy the real `k8s/mysql.yaml` + `k8s/deployment.yaml` to kind/Minikube |
| 17:45 – 18:15 | 0.5 hr | **6. AI-Assisted Pipeline Review** | Feed a real Trivy/Dockerfile/manifest issue from this repo to the AI assistant |

**End of Day 1:** 18:15

---

## Notes

- Module order and time allocations are fixed per `CLAUDE.md` Section 3 — do not reorder or resize without updating that table first.
- Break/lunch placement is a scheduling default (not specified in `CLAUDE.md`); adjust timing if the venue or trainee group needs differ, but keep total module time at 8.0 hrs.
- Module 3 (Jenkins) and Module 5 (Kubernetes) are the two longest blocks — factor in real build/apply/rollout wait time when running these labs live, not just typing time.
- Module 4's seeded finding is Seed 1 in `orderflow-lite/TRAINING_SEEDS.md` (Trivy/`jest-junit`/`uuid`). Do not restate the seed's full details in module content — reference the guide file per the CLAUDE.md quality checklist.
- Each module's four artifacts (Concept Note, Worked Example, Hands-On Lab, Facilitator Notes) are generated separately per module — this schedule is the day-level index only.
