# Activity: "Fix the Broken Playbook"

**Slot in schedule:** Day 2, right after `06_Playbooks`, post-lunch session
**Duration:** 25–30 minutes total
**Format:** Teams of 2–3, competitive, live on their lab control nodes
**Goal:** Reinforce playbook syntax, privilege escalation, variables, and module basics through debugging rather than writing from scratch — debugging forces closer reading than authoring does.

---

## 1. Setup (do this before the session starts)

1. Copy `site.yml` and `inventory.ini` (provided separately) into a shared location participants can pull from — e.g. a `broken-playbook/` folder in the training repo, or hand out via a quick `scp`/shared volume in your Podman lab setup.
2. Confirm the target managed host in your lab image has the `nginx` package available in its repos (adjust the package name in the playbook if your container image uses a different distro — see note in the YAML).
3. Have `site-solution.yml` open on your own machine, not shared yet.
4. Write these three rules on the whiteboard/slide before revealing the task:
   - You may NOT delete and rewrite from scratch — only fix what's broken.
   - You may NOT use Kahoot/search engines for the exact error — but `ansible-playbook --syntax-check` and `-vvv` are fair game and encouraged.
   - First team to a clean run **and** a correct explanation of every bug wins (this stops teams from randomly poking at YAML until it works without understanding why).

---

## 2. The Screenplay (what you actually say and do)

**[0:00 – Setup, energy beat]**

> "Alright, hands off keyboards for a second. I'm about to hand you a playbook. It looks fine. It is not fine. Somewhere in here are four bugs, and they're the same four bugs I see in real playbooks in production, all the time. Your job: find them, fix them, and be ready to tell me *why* each one broke things — not just that it works now."

Pause for groans/laughter. This is intentional — frame it as "these are real bugs you WILL hit," not a trick.

**[0:01 – Distribute]**

> "Pull `site.yml` and `inventory.ini` from [wherever you're hosting them]. Get it onto your control node. You have 15 minutes. I'll call time at 5 minutes remaining."

Hand out / announce the path. Do NOT explain the bugs yet.

**[0:02 – Teams form]**

If pairs aren't already set from earlier pairing rotation, quickly assign: "Turn to the person next to you, that's your team."

**[0:03 – 0:16 — Working time]**

Walk the room. Do NOT fix things for people. If a team is stuck for more than ~3 minutes on the *same* bug, drop a hint from the hint ladder below rather than the answer.

**Hint ladder (use sparingly, in order):**
1. "Run it with `-vvv` and read the very first error, not the last one."
2. "Check what's above and below the line the error points to — YAML errors often report the wrong line."
3. "Is this task allowed to do what it's trying to do, as the user it's running as?"
4. (Last resort, only with <3 min left) name the specific task that's broken.

**[0:11 — 5 minutes remaining]**

> "Five minutes! If you've found all four, start writing down — in one sentence each — why each one broke."

**[0:16 — Time's up]**

> "Hands off keyboards. Who's got a clean run?"

Ask the first team that raises their hand to share their screen (or read out) ONE bug and its fix. Don't let one team explain all four — spread it across teams so everyone's engaged in the reveal, not just the winner.

**[0:16 – 0:25 — Reveal & debrief]**

Go bug by bug (see Section 4 below for the exact explanations). For each:
- Ask: "Who found this one? What was the symptom?"
- Confirm/complete the explanation yourself.
- Tie it back to something concrete: "This is the #1 reason new hires' first playbook fails in real environments."

**[0:25 – Close]**

> "Notice none of these were exotic. Bad indentation, wrong privilege, a typo in a module name, and a variable that was never defined. That's 90% of real-world Ansible debugging. The fix is always: read the error from the top, and don't assume the line number is exactly where the problem is."

Transition directly into whatever's next on Day 2 (per your sequencing notes, this is a good moment before or after `17_Tags` if you decide to move it here).

---

## 3. Winning condition & scoring (optional, if you want a leaderboard tie-in)

- 1st team to clean run + correct explanations: 3 points
- 2nd team: 2 points
- Any team that finds all 4 bugs even if not first: 1 point
- Track on the same whiteboard/leaderboard you're using for Kahoot — keeps a running "energy score" across the week.

---

## 4. The Four Bugs (facilitator answer key)

These map to the tasks in `site.yml`. Full solution file is provided as `site-solution.yml` — do not distribute this until after the debrief.

| # | Bug | Symptom participants will see | Fix |
|---|-----|-------------------------------|-----|
| 1 | Missing `become: true` on package install task | Permission denied / package manager fails | Add `become: true` at play or task level |
| 2 | Wrong module name: `ansible.builtin.servics` (typo) instead of `ansible.builtin.service` | "couldn't resolve module/action" error, clearly points at the exact line | Fix the typo |
| 3 | `notify: Restart nginx` is attached to the "Install nginx" task instead of the "Deploy nginx config from template" task | Playbook runs with no errors. Package installs fine. But if someone edits the template and re-runs, the handler doesn't fire because the package task reports "ok" (already installed), not "changed" — config changes silently don't take effect (a genuinely "silent" bug, no error thrown) | Move `notify: Restart nginx` to the template task |
| 4 | Template `nginx.conf.j2` references `{{ nginx_port }}`, but the play only defines `http_port`, never `nginx_port` | "'nginx_port' is undefined" error, thrown only when the template task runs | Either rename the var in the template to `http_port`, or add `nginx_port: 80` to `vars:` |

**Why this order matters for the debrief:** bugs 1 and 4 throw loud errors (easy — the playbook stops and tells you), bug 2 throws an error pointing at the exact broken line (easy), but bug 3 is the interesting one: the playbook runs green, top to bottom, no errors at all. It only reveals itself if someone changes the template and re-runs, expecting the service to pick up the change. Call this out hard in the debrief: **"green output does not mean correct behavior."** That's the single most valuable lesson in this whole exercise.

---

## 5. Facilitator notes / things that can go wrong

- **If a team "fixes" bug 3 by accident** (e.g. they reformat the whole file and it happens to become correctly indented) — still ask them to explain why the original was wrong. Don't let a lucky fix skip the learning.
- **If the corporate network blocks something in your Podman lab** (per your Day 1 risk note) — have a fallback: this activity can run entirely offline on the control node against a local container, no external package repo access needed if you pre-bake nginx into your managed-host image.
- **If a team finishes early**, give them a stretch task: "Add a handler that also reloads on inventory changes" or "Parameterize the port using group_vars instead of play vars" — keeps fast finishers from getting bored and derailing the room.
