# Plan de desacoplamiento Replit — {proyecto}

**Contrato:** {id@version}  
**Matriz:** {enlace/versión}  
**Estado A2:** pendiente / corregido  
**Gate G2:** pendiente / aprobado

## Orden y grafo

```mermaid
flowchart LR
  L1[Conocimiento operativo] --> L2[Equivalencias funcionales]
  L2 --> L3[Tooling y configuración]
  L3 --> L4[Manifests y lockfiles]
  L4 --> L5[Residuos y cierre]
```

| Lote | IDs | Crea | Modifica | Elimina | Consume | Guardas | Manifest/lockfile | Depende de | Perfil | Smoke |
|---|---|---|---|---|---|---|---|---|---|---|

## Condiciones de paralelismo

Para cada par paralelo, demostrar: escrituras disjuntas · sin produce/consume · sin manifest o
regeneración compartida · sin mitades del mismo contrato · smokes conmutativos. Sin las cinco:
secuencial.

## Lote {n} — {nombre}

- **Contrato/IDs:** {…}
- **Perfil:** puntero / intermedio / bajo coste
- **Precondiciones/Ps:** {…}
- **Permitidos:** {lista cerrada}
- **Protegidos:** {lista}
- **Forma del cambio:** {pseudodiff/contrato}
- **Verificación:** `{comando}` → `{salida/predicado}`
- **Smoke positivo propio:** `{comando}` → `{señal + ventana}`
- **Rollback:** {procedimiento}
- **Detención:** si {condición}, detener y reportar; no adaptar.
- **Handoff:** {estado exacto para consumidores}

## Paridad pendiente

| ID | Caso baseline | Después | Contrafactual | Datos/rollback | Revisor |
|---|---|---|---|---|---|

## Fuera de alcance

- {lista explícita}

## Gate G2

- [ ] A2 adjunto y objeciones con desenlace.
- [ ] Ps bloqueantes resueltas.
- [ ] Lotes, grafo, smokes y rollback aprobados.
- [ ] Aprobación humana registrada.
