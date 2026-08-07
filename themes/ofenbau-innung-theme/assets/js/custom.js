// Menu
const toggle = document.querySelector(".nav-toggle");
const nav = document.getElementById("site-nav");

if (toggle && nav) {
  toggle.addEventListener("click", () => {
    const open = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!open));
    nav.classList.toggle("is-open", !open);
  });
}

// Gallery modal
const galleryEl = document.querySelector("[data-gallery]");
const modal = document.getElementById("gallery-modal");

if (galleryEl && modal) {
  const images = Array.from(galleryEl.querySelectorAll("img"));
  const modalImg = modal.querySelector(".gallery-modal-img");
  const btnClose = modal.querySelector(".gallery-modal-close");
  const btnPrev = modal.querySelector(".gallery-modal-prev");
  const btnNext = modal.querySelector(".gallery-modal-next");
  let current = 0;

  function show(index) {
    current = (index + images.length) % images.length;
    modalImg.src = images[current].src;
    modalImg.alt = images[current].alt;
    modal.removeAttribute("hidden");
    document.body.style.overflow = "hidden";
    btnClose.focus();
  }

  function close() {
    modal.setAttribute("hidden", "");
    document.body.style.overflow = "";
    images[current].focus();
  }

  images.forEach((img, i) => {
    img.setAttribute("tabindex", "0");
    img.addEventListener("click", () => show(i));
    img.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        show(i);
      }
    });
  });

  btnClose.addEventListener("click", close);
  btnPrev.addEventListener("click", () => show(current - 1));
  btnNext.addEventListener("click", () => show(current + 1));

  modal
    .querySelector(".gallery-modal-backdrop")
    .addEventListener("click", close);

  document.addEventListener("keydown", (e) => {
    if (modal.hasAttribute("hidden")) return;
    if (e.key === "Escape") close();
    if (e.key === "ArrowLeft") show(current - 1);
    if (e.key === "ArrowRight") show(current + 1);
  });
}
