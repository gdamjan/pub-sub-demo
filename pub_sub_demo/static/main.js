document.addEventListener("DOMContentLoaded", function (event) {
  // this is a prototype! in the real world the payload needs to be proper, escaped and signed
  const url =
    "/subscribe?payload=" + JSON.stringify({ topics: ["one", "two"] });
  const evtSource = new EventSource(url);
  const eventLog = document.querySelector("#eventLog");

  evtSource.addEventListener("message", function (event) {
    const newElement = document.createElement("li");
    newElement.innerText = "message: " + event.data;
    eventLog.appendChild(newElement);
  });

  evtSource.addEventListener("open", function (event) {
    document.querySelector("div.left").style.backgroundColor = "";
  });

  evtSource.addEventListener("error", function (event) {
    document.querySelector("div.left").style.backgroundColor = "#ffa0a0";
  });

  // get stats
  async function nchan_status() {
    const nchanStatus = document.querySelector("#nchan_stub_status pre");
    const resp = await fetch("nchan_stub_status");
    const text = await resp.text();
    nchanStatus.innerText = text;
  }
  nchan_status();
  setInterval(nchan_status, 5000);

  async function publish_dummy_data() {
    let url = "/publish?topic=one";
    let data = { message: `test: ${new Date().toGMTString()}` };
    let headers = {
      "X-Secret": "one two three",
      "content-type": "application/json",
    };

    let res = await fetch(url, {
      method: "POST",
      headers: headers,
      credentials: "same-origin",
      body: JSON.stringify(data),
    });
    console.log(await res.text());
  }

  document
    .getElementById("publish")
    .addEventListener("click", publish_dummy_data);
});
