const copyText = (id) => {
  const text = document.getElementById(id).value;

  window.focus()
  navigator.clipboard.writeText(text)

  event.currentTarget.innerText = "Code copied !"
  event.currentTarget.style.background = "green"

}

export { copyText }
