document.addEventListener("turbo:load", function() {
  var toggle = document.getElementById("top-menu-toggle");
  var sideMenu = document.getElementById("side-menu");

  if (toggle && sideMenu) {
    toggle.addEventListener("click", function() {
      sideMenu.classList.toggle("open");
    });
  }
});