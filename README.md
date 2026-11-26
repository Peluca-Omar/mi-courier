# Mi Courier

App responsive para un único usuario, en celular y PC. Clientes sin teléfono, pedidos con varios artículos, compras por encargo o solo envío, pagos parciales, fechas con calendario nativo y saldos en USD. Los envíos desconocidos quedan por calcular. Solo envío tiene compra y comisión cero también por restricción de base de datos.

## Activar la base de datos

1. Crea tu proyecto en https://supabase.com .
2. En SQL Editor ejecuta `supabase.sql` una sola vez.
3. En Authentication > Users crea tu usuario con correo y contraseña. En la configuración de autenticación desactiva la posibilidad de registrar usuarios nuevos. La app no ofrece registro público.
4. Copia `.env.example` a `.env`. Completa la URL de tu proyecto y su clave **publishable** (o anon pública). Nunca uses una clave service_role ni secret en esta app.
5. Ejecuta `npm install` y `npm run dev`.

Los registros se guardan directamente en PostgreSQL de Supabase. Las políticas RLS limitan cada registro al usuario propietario. La app confirma el guardado solo tras una respuesta exitosa del servidor. Requiere internet para consultar y guardar. Actualizar recarga los datos que hayas cambiado desde otro dispositivo.

## Celular y PC

Ejecuta `npm run build` y publica la carpeta `dist` en un alojamiento HTTPS como Netlify o Vercel, configurando las dos variables de entorno al compilar. Abre la misma URL en ambos dispositivos. En el celular puedes agregarla a la pantalla de inicio; la opción de instalación depende del navegador. No incluye funcionamiento sin conexión.

## Copias de seguridad

**Las copias automáticas todavía requieren configuración en el servicio.** Antes de usar datos reales, activa y comprueba la política de backups de tu proyecto Supabase (disponibilidad, retención y restauración dependen del plan contratado). Si el plan no incluye backups automáticos, configura una tarea externa de respaldo de PostgreSQL o elige un plan que los incluya. Verifica una restauración de prueba.

El botón **Copia completa** descarga un JSON con clientes, pedidos y pagos. Guarda copias periódicas fuera del dispositivo. **Exportar CSV** descarga un resumen de pedidos compatible con Excel. El JSON sirve como copia adicional; esta primera versión no incluye importador automático. La base de datos en la nube por sí sola no sustituye una copia de seguridad.

## Comprobación

`npm run build` valida la compilación. Después de configurar Supabase, comprobar con una cuenta de prueba: crear cliente; pedido con dos artículos; pago parcial; envío pendiente; actualizar el envío; saldo a favor; modalidad solo envío sin comisión; abrir la misma cuenta en otro dispositivo; exportar copias. Intentar leer registros desde otra cuenta debe devolver únicamente sus propios datos.
