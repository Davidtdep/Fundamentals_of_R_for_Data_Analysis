# Estudio sobre la Enfermedad de Pérdida de Tejido en Arrecifes Coralinos

## Contexto del estudio

Este conjunto de datos representa un estudio hipotético sobre una enfermedad emergente que causa pérdida de tejido en corales escleractinios (corales duros) en el Caribe mexicano. En los últimos años, diversas enfermedades han afectado severamente a los arrecifes coralinos, siendo un ejemplo reciente la Enfermedad de Pérdida de Tejido en Corales Duros (SCTLD, por sus siglas en inglés), que ha devastado arrecifes en todo el Caribe.

El estudio se realiza en diferentes localidades, incluyendo zonas dentro y fuera de áreas marinas protegidas. Los investigadores están interesados en identificar qué factores ambientales están asociados con la presencia de la enfermedad, y si las áreas marinas protegidas proporcionan algún tipo de amortiguamiento contra estos brotes epidemiológicos.

## Variables de estudio

- **enfermedad_coral**: Variable de respuesta binaria que indica si se observaron colonias de coral con la enfermedad (Presente) o no (Ausente) en el sitio de muestreo.

- **temperatura**: Temperatura promedio del agua medida en grados Celsius (°C). Se ha hipotetizado que temperaturas más elevadas pueden desencadenar o exacerbar brotes de enfermedades en corales.

- **profundidad**: Profundidad del sitio de muestreo medida en metros. La profundidad puede influir en la incidencia de enfermedades a través de diversos factores como luz, presión y fluctuaciones térmicas.

- **zona_protegida**: Variable categórica binaria que indica si el sitio está dentro de un área marina protegida (Protegida) o fuera de ella (No protegida). Las áreas protegidas suelen tener mejores prácticas de manejo y menos impactos antropogénicos.

## Objetivo del análisis

Este análisis tiene dos objetivos principales con aplicación práctica directa:

1. **Determinar factores de riesgo ambiental**: Cuantificar cómo la temperatura y la profundidad afectan el riesgo de presencia de la enfermedad, para poder desarrollar sistemas de alerta temprana basados en monitoreo de condiciones ambientales.

2. **Evaluar la eficacia de áreas marinas protegidas**: Determinar si las áreas protegidas reducen el riesgo de enfermedad, lo que podría informar políticas de manejo y conservación.

El análisis se centrará en:

- Calcular odds ratios (OR) bivariados para entender el efecto individual de cada factor ambiental.
- Calcular odds ratios ajustados para evaluar si estos efectos se mantienen al considerar el estado de protección del área.
- Comparar los OR crudos vs. ajustados para determinar posibles confusores o modificadores del efecto.

Los resultados podrían proporcionar información valiosa para:
- Predecir brotes de la enfermedad basados en condiciones ambientales
- Optimizar estrategias de monitoreo y respuesta rápida
- Evaluar y mejorar la efectividad de las áreas marinas protegidas en el contexto de enfermedades emergentes
- Desarrollar estrategias de manejo adaptativo ante el cambio climático