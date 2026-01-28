const server = Bun.serve({
    port: 3000,
    // routes: {
    //     "/": new Response("OK"),
    // },
    
    fetch(req) {
        const url = new URL(req.url)
        const path = url.pathname === "/" ? "index.html" : url.pathname
        const file = Bun.file(`./dist/${path}`)

        return file ? new Response(file) : new Response("Not Found", { status: 404 })
    }
})

console.log(`Server running at ${server.url}`)