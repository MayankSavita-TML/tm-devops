# Day 2 Schedule - DevOps 2-Day Course (OrderFlow-Lite)

**Total instructional time:** 8.0 hrs (7 modules) + breaks/lunch = full training day

| Time | Duration | Module | OrderFlow-Lite tie-in |
|---|---|---|---|
| 09:00 – 10:00 | 1.0 hr | **7. Terraform for Local Infrastructure** | Apply the real `terraform/` prerequisite config |
| 10:00 – 11:00 | 1.0 hr | **8. Ansible Host Configuration** | Run the real `ansible/prepare-host.yml` |
| 11:00 – 11:15 | 0.25 hr | *Break* | |
| 11:15 – 12:45 | 1.5 hrs | **9. Kubernetes Deployment and Pipeline Integration** | Trigger the real Jenkinsfile's `Kubernetes Deploy` stage, do a rolling update + rollback |
| 12:45 – 13:30 | 0.75 hr | *Lunch* | |
| 13:30 – 14:30 | 1.0 hr | **10. DevSecOps Pipeline Controls** | Add GitLeaks gate against the real seeded secret |
| 14:30 – 14:45 | 0.25 hr | *Break* | |
| 14:45 – 17:15 | 2.5 hrs | **11. End-to-End Capstone** | Checkout `capstone-seeded-failure`, run full pipeline, diagnose using `CAPSTONE_FAILURE_GUIDE.md` |
| 17:15 – 17:30 | 0.25 hr | *Break* | |
| 17:30 – 18:00 | 0.5 hr | **12. AI-Assisted Incident Analysis** | Feed real `kubectl logs` output from the seeded failure to the AI assistant |
| 18:00 – 18:30 | 0.5 hr | **13. Architecture Review and Closure** | Discussion only — reference the "independent worker loop per replica" scaling caveat as a talking point |

**End of Day 2:** 18:30

---

## Notes

- Module order and time allocations are fixed per `CLAUDE.md` Section 4 — do not reorder or resize without updating that table first.
- Break/lunch placement is a scheduling default (not specified in `CLAUDE.md`), consistent with the Day 1 pattern; adjust timing per venue/group needs but keep total module time at 8.0 hrs.
- Module 11 (End-to-End Capstone) is the anchor of the day — the extra break immediately before and after it is intentional, since it's the longest single block and the point where diagnosis fatigue is most likely.
- Module 9's rollback lab and Module 11's capstone both assume Modules 3–5 (Jenkins, Docker, Kubernetes) and Day 1's kickoff pipeline are already working — this schedule assumes Day 1 completed successfully and its labs' end states are the starting state here.
- Module 10's seeded finding is Seed 2 in `orderflow-lite/TRAINING_SEEDS.md` (GitLeaks / `scripts/legacy-webhook-notify.sh`). Do not restate the seed's full details in module content — reference the guide file per the CLAUDE.md quality checklist.
- Module 11's seeded failure (`CAPSTONE_FAILURE_GUIDE.md`) currently lives only on the `capstone-seeded-failure` branch, not `main` — confirm trainees check out that branch before starting the lab.
- Module 13 is discussion-only, no lab — plan for it to run over into a wrap-up conversation rather than timeboxing it strictly if the capstone ran long.
- Each module's four artifacts (Concept Note, Worked Example, Hands-On Lab, Facilitator Notes) are generated separately per module — this schedule is the day-level index only.
