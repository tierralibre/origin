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

A nivel de computacion, esta python para hacer computacion distribuida. Y elixir con lo que orquestra.

Cada nodo se actualiza por el aire via wifi, conectado con una clave SSH.

Tambien tiene un puerto usb donde se puede acceder a la termirnal iEx, que permite ejecutar codigo y ver el log del sistema en tiempo real.

## Estructura

fw -> firmware de nerves
origin_system -> sistema pi zero w con python y python-envirophat
ui -> applicacion y interface web. http://phoenixframework.org

ui/lib/application.ex

ui/lib/earth
interaccion con el entorno, adquisicon de datos. Actuacion.

Ui.Earth.EnvirophatServer

Se conecta con el sensor envirophat, via su libreria de python, para obtener datos de temperatura, presion, compass, lux.
Los guarda en Era.System, que crea una copia en memoria server.ex y lo copia en disco, en un directoria. Cada servidor un archivo. Esto se puede ver como un bloque. 

UiWeb.Endpoint y UiWeb.Presence
Son de Phoenix y nos dan la aplicacion web y Presence capacidad de saber quien esta online de usuarios conectados a la web app.

ui/era/
capa distribuida de procesado y guardado de datos
en futuro con capacidad de ser inmutable a traves de firmar los bloques.

Era.System
Se encarga de tener un grafico en memoria con una copia en disco que puede ser usado como un estado distribuido. Evolucionando a bloques de datos conectados. Con una red de firmas de confianza.

Era.ProcessRegistry
Se encarga de tener una copia de cada cache por su nombre de proceso ("envirophat").

Era.Database
Se encarga de guardar y leer el estado de server.ex en disco. (Estado = bloque)

Era.Cache
Guarda un grafico de server.ex en memoria, supervisado.

# Como

conectar por usb en mac. (linux y windows es una conexios usb uart via terminal)

```
screen /dev/tty.usbmodem* 115200
```

configuracion en ENV de la terminal:

NERVES_NETWORK_SSID = wifi ssid
NERVES_NETWORK_PSK = clave vifi

```
export MIX_TARGET=origin_system
export NERVES_NETWORK_SSID=the_network_name
export NERVES_NETWORK_PSK=the_network_password
```

desde origin/fw/
```
mix deps.get
mix nerves.release.init
mix firmware
mix firmware.burn
```

para compilar y hacer push del firmware.
esta configurado con la clave ssh en:
.ssh/id_rsa.pub
configuracion en: /fw/config/config.exs

Por el aire
```
mix firmware
mix firmware.push origin.local
```

Con tarjeta micro SD en el ordenador
```
mix firmware
mix firmware.burn
```

para crear nuestro propio sistema mini linux con erlang, elixir y python.

```
export MIX_TARGET=origin_system
mix deps.get
mix nerves.system.shell

make menuconfig
make savedefconfig

```

para instalar paquetes python propiosque estan en https://pypi.python.org/pypi


desde origin/fw

```
mix nerves.system.shell
apt-get update
apt-get install python-setuptools
cd /nerves/env/platform/buildroot
utils/scanpypi envirophat -o package
apt-get install nano
nano 

```
scanpypi

```
donde
source "package/python-enum34/Config.in"

nuevo
source "package/python-envirophat/Config.in"

final
source "package/python-enum34/Config.in"
source "package/python-envirophat/Config.in"
```

volver ha /nerves/build
```
cd /nerves/build
make menuconfig
make savedefconfig
```

customizar con menuconfig

![](https://raw.githubusercontent.com/tierralibre/origin/master/docs/media/nerves_buildroot.gif)



## Enlaces

https://nerves.build/posts/nerves-0-11
https://github.com/maximeh/buildroot/blob/master/docs/manual/adding-packages-python.txt














