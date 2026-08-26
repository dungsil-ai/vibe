# Labels

Skills speak in terms of canonical roles. This file maps those roles to actual label strings used in this repository's issue tracker.

## Triage Status Roles

Five states incoming requests move through, used in the triage stage of `vibe-plan`.

| Canonical Role    | Tracker Label       | Meaning                                                  |
| ----------------- | ------------------- | -------------------------------------------------------- |
| `needs-triage`    | `상태:분류필요`     | Maintainer must evaluate this issue                      |
| `needs-info`      | `상태:정보필요`     | Awaiting additional info from reporter                   |
| `ready-for-agent` | `상태:에이전트작업` | Spec is complete and ready for AFK agent implementation  |
| `ready-for-human` | `상태:사람작업`     | Must be implemented by a human directly                 |
| `wontfix`         | `상태:처리안함`     | Will not be addressed                                    |

When a skill mentions a role (e.g. "apply the ready-for-agent triage label"), use the corresponding label string from this table.

Edit the right column to match the vocabulary actually used in your tracker.

## Planning Labels

Used by `vibe-deep-plan` when charting decision maps. Map labels designate the effort's index issue, while type labels record how decision tickets get resolved.

| Canonical Role | Tracker Label    | Meaning                                                             |
| -------------- | ---------------- | ------------------------------------------------------------------- |
| map            | `상태:초안`       | This issue is a decision map — index of effort, not actionable task |
| research       | `유형:조사`       | Resolved by background subagent reading primary sources             |
| prototype      | `유형:프로토타입` | Resolved by throwaway artifact to gauge reactions                   |
| grilling       | `유형:인터뷰`     | Resolved by dialogue asking one question at a time                  |
| task           | `유형:작업`       | Manual prerequisite work that must precede decisions                |

## Two Axes

`status:` answers "what state is this in", while `type:` answers "how does this resolve". An issue carries **at most one label per axis**.

`status:draft` resides on the same axis as triage statuses and therefore excludes triage statuses. A decision map is an in-progress planning artifact rather than a request awaiting evaluation, and is not subject to triage. For the same reason, decision tickets on a map carry only `type:` labels. Triage statuses apply again only after the map finishes and `vibe-plan` publishes implementation tickets.
