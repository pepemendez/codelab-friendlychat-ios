# FriendlyChat - Firestore
Test con conexion a Firestore 

Ejercicio Técnico
Requisitos:
<ul>
<li> La aplicación debe permitir a los usuarios iniciar sesión con su cuenta de correo electrónico y contraseña. <span style="color: green">&#10003;</span></li>
<li> Los usuarios deben poder ver una lista de conversaciones a las que están suscritos. <span style="color: green">&#10003;</span></li>
<li> Al seleccionar una conversación, los usuarios deben poder ver todos los mensajes de la conversación y enviar nuevos mensajes. <span style="color: green">&#10003;</span></li>
<li>  Los usuarios deben poder ver su perfil y actualizar su nombre de usuario y foto de perfil. <span style="color: green">&#10003;</span></li>
<li> Todos los datos de usuario, conversación y mensaje deben ser almacenados en Firebase Firestore. <span style="color: green">&#10003;</span></li>
<li> Debe haber un sistema de autenticación y autorización para garantizar que los usuarios solo puedan acceder a las conversaciones a las que tienen acceso. <span style="color: green">&#10003;</span></li>
<li>La aplicación debe seguir los principios de Clean Architecture, con separación de
responsabilidades en capas, tales como Domain, Data, y Presentation. (A medias)</li>
<br/>
Puntos por considerar:
<ul>
<li>El código debe ser claro y bien organizado, y seguir los principios de Clean Architecture. (A medias) </li>
<li>Debe haber una buena cobertura de pruebas unitarias. (Faltó tiempo) </li>
<li>La aplicación debe ser fácil de usar y tener una interfaz de usuario intuitiva.<span style="color: green">&#10003;</span></li>
<li>El código debe estar escrito en Swift.<span style="color: green">&#10003;</span></li>
<li>Debe utilizarse Firebase Firestore como plataforma de backend.<span style="color: green">&#10003;</span></li>
<li>Para completar esta prueba técnica, el desarrollador deberá entregar una aplicación de iOS
completamente funcional que cumpla con los requisitos mencionados anteriormente. Además,
deberá proporcionar el código fuente de la aplicación y cualquier documentación necesaria
para ejecutarla y compilarla. También se recomienda proporcionar cualquier comentario
adicional sobre las decisiones de diseño y la estructura del código.<span style="color: green">&#10003;</span></li>
</ul>
<br/>

Adicionales incluidos en el proyecto:
<br/>

<ul>
<li>Se debe de soportar iOS 13 o superior.<span style="color: green">&#10003;</span></li>
<li>Se debe de ocupar XCode 13 o superior.<span style="color: green">&#10003;</span></li>
<li>Se debe de ocupar Swift 5.</li>
<li>El código fuente se debe de subir en un servidor público de GIT (GitHub/BitBucket/etc...).<span style="color: green">&#10003;</span></li>
<li>Se consideran 3 días(fin de semana) para esta prueba.</li>
</ul>

<br/>
Consideraciones
<ul>
<li>El proyecto se creó a partir de: <br/>
 - [Firebase Swift Codelab](https://codelabs.developers.google.com/codelabs/firebase-ios-swift/).
 <br/> Por tanto, la versión que se utilizó de Swift se heredó del inicio del proyecto
</li>
<li>Para correr el proyecto es necesario ir a la ruta /ios-starter/swift-starter</li>
<li>Se consideran chats publicos y privados, por tanto los usuarios que ingresen a la aplicación no podran ver los chats privados (o no deberían)
<p align="center">
  <img src="imagenes/IMG_0001.PNG"  width="750"/>
</p>
</li>
<li>Como funcionalidad añadida se muestran las imagenes de los usuarios, estas se almacenan al momento de enviar el mensaje, por tanto, cuando el usuario actualiza su imagen de perfil o su nombre, no se ve reflejado en la conversación
<p align="center">
  <img src="imagenes/IMG_0002.PNG"  width="750"/>
</p>
</li>
<li>Debido a las limitaciones de las cuotas del proyecto de firebase, el envio de imágenes por chat no se terminó.</li>
<li>Se utiliza RxSwift para la mayor parte del proyecto.</li>
</ul>
<br/>
<br/>

Opcionales que me gustaría implementar
<ul>
<li>Mejorar la interfaz de usuario</li>
<li>Mejorar la paleta de colores</li>
<li>Añadir animaciones</li>
<li>Mejorar la estructura del código con los siguientes puntos:
<ul>
<li>Añadir una clase wrapper para el manejo de imágenes de Firebase</li>
<li>Añadir una clase wrapper para el manejo de Autenticación</li>
<li>Añadir una clase wrapper para el manejo de Google SignIn</li>
<li>Añadir una clase para el manejo de strings dentro de la aplicación</li>
<li>Añadir una clase wrapper para el manejo de imágenes de Firebase</li>
<li>Integrar IQKeyboardManager para el manejo del teclado, que es importante en un chat </li>
<li>Corregir la integración de imagenes en el chat, se utilizó mayoritariamente el código inical del proyecto cambiando breves cosas, pero queda pendiente.</li>
<li>Mejorar la experiencia de usuario</li>
<li>Incluir localización para los strings dentro de la aplicación</li>
<li>Terminar el modelado de datos</li>
<li>Crear pruebas unitarias</li>
<li>Migrar a Swift 5 y Swift UI</li>
<li>Utilizar un servicio más robusto o consultar más a detalle la funcionalidad Firebase Firestore</li>
</ul>
</li>
</ul>
</li>
</ul>

<br/>
<br/>

El proyecto se probó en iOS 16.3 en un iPad 6ta generación y en simulador de iPhone 11 iOS 16.2,
no se tuvo posibilidad de probar en un iPhone real debido a limitaciones de la cuenta de developer.

<br/>

El proyecto se realizó en una Macbook Pro, M2 2022 en el OS Monterrey 12.6.1


## License
See [LICENSE](LICENSE)
