# Origin
Ejemplo de como usar http://nerves-project.org
Con https://www.raspberrypi.org/products/raspberry-pi-zero-w/
Instalando python y paquetes como envirophat para hablar con el modulo ambiental.
https://shop.pimoroni.com/collections/raspberry-pi/products/enviro-phat

Tiene canales de phoenix para mensajeria
Un GenServer que guarda datos en disco y los recupera.

Primera iteracion.

La idea es poder usar los canales para subscribirse.

Y usar la parte de datos para crear un sistema distribuido, guardando los datos en bloques entrelazados, inspirado en Archain.
http://archain.org

De esta forma se puede crear un nodo de puede adquirir datos del entorno, junto con datos externos, procesarlos y tomar acciones. Siempre con una copia en disco para poder recuperarse si se va la electricidad.

Con el wifi se podria hacer una red mesh. Esto podria crear nodos que se conectan solos y expanden la red.

El pi zero consume mas o menos 1.1 Watts

Este mismo concepto se puede llevar al pi3, que podria ser usado como gateway lora, guardando todo en disco. Y pudiendo tomar decisiones locales.

Al estar con nerves que usa BEAM todos los nodos se pueden conectar entre si. Y se convierte en un sistema de computacion distribuida. 




