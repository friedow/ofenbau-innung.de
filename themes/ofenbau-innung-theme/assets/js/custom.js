// Menu
const toggle = document.querySelector(".nav-toggle");
const nav = document.getElementById("site-nav");
const navClose = document.querySelector(".nav-close");

function openNav() {
  toggle.setAttribute("aria-expanded", "true");
  nav.classList.add("is-open");
  document.body.style.overflow = "hidden";
}

function closeNav() {
  toggle.setAttribute("aria-expanded", "false");
  nav.classList.remove("is-open");
  document.body.style.overflow = "";
  nav.querySelectorAll(".has-dropdown.is-open").forEach((li) => {
    li.classList.remove("is-open");
    li.querySelector(".dropdown-toggle")?.setAttribute("aria-expanded", "false");
  });
}

if (toggle && nav) {
  toggle.addEventListener("click", openNav);
}

if (navClose) {
  navClose.addEventListener("click", closeNav);
}

nav?.querySelectorAll(".dropdown-toggle").forEach((btn) => {
  btn.addEventListener("click", () => {
    const li = btn.closest(".has-dropdown");
    const open = li.classList.toggle("is-open");
    btn.setAttribute("aria-expanded", String(open));
  });
});

nav?.querySelectorAll("a").forEach((a) => {
  a.addEventListener("click", () => {
    if (nav.classList.contains("is-open")) closeNav();
  });
});

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && nav?.classList.contains("is-open")) closeNav();
});

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

  let touchStartX = 0;
  modal.addEventListener("touchstart", (e) => {
    touchStartX = e.changedTouches[0].clientX;
  }, { passive: true });
  modal.addEventListener("touchend", (e) => {
    const dx = e.changedTouches[0].clientX - touchStartX;
    if (Math.abs(dx) < 50) return;
    show(dx < 0 ? current + 1 : current - 1);
  }, { passive: true });
  modal.addEventListener("touchcancel", () => {
    touchStartX = 0;
  }, { passive: true });
}
