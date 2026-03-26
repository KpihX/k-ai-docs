# 🩺 Doctor and Recovery

> **Problem we had:** when agent systems drift, a weak "doctor" command only tells you that something is wrong. It does not help you get back to a known-good state.

So `k-ai` doctor is not only diagnostic.
It is also recovery-oriented.

---

## What Doctor Checks

Doctor now looks at more than environment basics.

It checks:

- config coherence
- legacy-to-canonical config normalization
- tool registry vs approval catalog alignment
- runtime-state integrity
- reset eligibility

This is important because many failures in agent systems are not "missing dependency" failures.
They are coherence failures.

---

## Why Reset Exists

Sometimes the best repair is not incremental.

Sometimes the safest path is:

```text
backup current state
then reset the broken layer
```

That is why doctor supports reset targets.

---

## Reset Targets

```bash
k-ai doctor --reset config
k-ai doctor --reset memory
k-ai doctor --reset sessions
k-ai doctor --reset all
```

And the same logic can be reached from chat:

```text
/doctor reset config
/doctor reset all
```

---

## Backup-First Philosophy

Reset is last resort, not first reflex.

So the intended model is:

```text
doctor audit
   │
   ├─ if fixable live, fix live
   ├─ if state is suspect, back it up
   └─ if badly broken, reset targeted layer
```

This preserves recoverability instead of trading one uncertainty for another.

---

## Visual Summary

```text
broken state suspected
   │
   ├─ audit coherence
   ├─ detect mismatches
   ├─ back up state
   └─ reset only what must be reset
```

See also:

- [🧪 Safety & Tests](safety-and-tests.md)
- [⚙️ Live Config](live-config.md)
- [🛠️ Tool Governance](tool-governance.md)
