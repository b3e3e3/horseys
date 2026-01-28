import { JSONEditor } from "@json-editor/json-editor";
import * as Horsey from "../schemas/horsey.schema.json"
import * as Skill from "../schemas/skill.schema.json"

import "spectre.css/dist/spectre.min.css"
import "spectre.css/dist/spectre-icons.min.css"
import "spectre.css/dist/spectre-exp.min.css"


let isGodot: boolean = false

type GlobalData = {
    ctx?: {
        horseys?: any
        skills?: any
        [key: string]: any
    }
    [key: string]: any
 }
const dummyData: GlobalData = {
    ctx: {
        horseys: ["horsey1.json"],
        skills: ["skill1.json"]
    }
};



const editorOptions = {
    theme: "spectre",
}

// window.onload = e => {
// }

window.addEventListener("godot.ready", event => {
    isGodot = true
    var $g: GlobalData = (window as any).$g || dummyData
    initialize($g)
});

window.onload = e => {
}

function initialize($g: any) {

    console.log("Is Godot?", isGodot)     

    new JSONEditor(document.getElementById("horsey-editor"), { schema: Horsey, no_additional_properties: true, ...editorOptions })
    new JSONEditor(document.getElementById("skill-editor"), { schema: Skill, no_additional_properties: true, ...editorOptions })

    document.getElementById("file-col").appendChild(createAccordion("horseys", $g.ctx.horseys.value))
    document.getElementById("file-col").appendChild(createAccordion("skills", $g.ctx.skills.value))
}

function selectFile(file: string, category: string) {
    console.log(`Selected ${file} from ${category}`)
}

export function createAccordion(name: string, list: string[], depth: number = 1): Element {
    var accordion: Element = document.createElement("div")
    accordion.classList.add("accordion")
    accordion.setAttribute("open", "true")

    var checkbox: Element = document.createElement("input")
    checkbox.setAttribute("type", "radio")
    checkbox.setAttribute("name", `${name}-accordion-radio`)
    checkbox.setAttribute("id", `${name}-accordion`)
    checkbox.setAttribute("hidden", "true")

    var label: Element = document.createElement("label")
    label.setAttribute("for", `${name}-accordion`)
    label.classList.add("accordion-header")

    var icon: Element = document.createElement("i")
    icon.classList.add("icon", "icon-arrow-right", "mr-1")

    label.appendChild(icon)
    label.append(name)

    var body: Element = document.createElement("div")
    body.classList.add("accordion-body")

    list.forEach(f => {
        var link: Element = document.createElement("a")
        link.classList.add(`ml-2`)
        link.innerHTML = f
        link.addEventListener("click", (ev: Event) => {
            ev.preventDefault()
            selectFile(f, name)
        })
        body.appendChild(link)
    })

    accordion.appendChild(checkbox)
    accordion.appendChild(label)
    accordion.appendChild(body)

    return accordion
}