// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import "preline"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    longPollFallbackMs: 2500,
    params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


// Preline theme switcher
// This code should be added to <head>.
// It's used to prevent page load glitches.
const html = document.querySelector('html');
const isLightOrAuto = localStorage.getItem('hs_theme') === 'light' || (localStorage.getItem('hs_theme') === 'auto' && !window.matchMedia('(prefers-color-scheme: dark)').matches);
const isDarkOrAuto = localStorage.getItem('hs_theme') === 'dark' || (localStorage.getItem('hs_theme') === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches);

if (isLightOrAuto && html.classList.contains('dark')) html.classList.remove('dark');
else if (isDarkOrAuto && html.classList.contains('light')) html.classList.remove('light');
else if (isDarkOrAuto && !html.classList.contains('dark')) html.classList.add('dark');
else if (isLightOrAuto && !html.classList.contains('light')) html.classList.add('light');


// technology search in 'new' form
// const searchTechnologiesInput = document.querySelector("#search-technologies")
const techButtons = document.querySelectorAll(".form-tech-button")

// if (searchTechnologiesInput) {
//     searchTechnologiesInput.addEventListener("keyup", (e) => {
//         const searchQuery = e.target.value.toLowerCase()
//         techButtons.forEach((button) => {
//             if (searchQuery && button.innerHTML.toLowerCase().includes(searchQuery)) {
//                 button.classList.remove("hidden")
//             } else {
//                 button.classList.add("hidden")
//             }
//         })
//     })
// }

if (techButtons.length > 0) {
    [...techButtons].forEach((button) => {
        button.addEventListener("click", (e) => {
            const techsString = document.querySelector("#technologies").value
            const techs = techsString === "" ? [] : techsString.split(", ")
            const newTech = e.target.querySelector(".tech-text").innerText
            const newTechs = techs.includes(newTech) ? techs.filter(t => t !== newTech) : [...techs, newTech]
            document.querySelector("#technologies").value = newTechs.join(", ")
            
        })
    })
}
