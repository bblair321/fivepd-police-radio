window.addEventListener("message", (event) => {
  if (event.data.action === "toggle") {
    document.getElementById("radioUI").style.display = event.data.state ? "block" : "none";
  }
});

function join() {
  const channel = document.getElementById("channelInput").value;
  fetch(`https://${GetParentResourceName()}/joinRadio`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ channel })
  });
}

function leave() {
  fetch(`https://${GetParentResourceName()}/leaveRadio`, {
    method: "POST"
  });
}

function closeUI() {
  fetch(`https://${GetParentResourceName()}/close`, {
    method: "POST"
  });
}
