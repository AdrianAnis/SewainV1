document.addEventListener("DOMContentLoaded", function () {
    var revealElements = document.querySelectorAll(".reveal-card, .reveal-header");

    var revealObserver = new IntersectionObserver(
        function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add("revealed");
                    revealObserver.unobserve(entry.target);
                }
            });
        },
        {
            threshold: 0.15,
            rootMargin: "0px 0px -40px 0px"
        }
    );

    revealElements.forEach(function (el) {
        revealObserver.observe(el);
    });

    var wishlistBtns = document.querySelectorAll(".property-wishlist");
    wishlistBtns.forEach(function (btn) {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();
            this.classList.toggle("active");

            this.classList.add("pop");
            var self = this;
            setTimeout(function () {
                self.classList.remove("pop");
            }, 400);
        });
    });

    var cards = document.querySelectorAll(".property-grid .property-card");
    cards.forEach(function (card) {
        card.addEventListener("mousemove", function (e) {
            var rect = card.getBoundingClientRect();
            var x = e.clientX - rect.left;
            var y = e.clientY - rect.top;
            var centerX = rect.width / 2;
            var centerY = rect.height / 2;
            var rotateX = ((y - centerY) / centerY) * -3;
            var rotateY = ((x - centerX) / centerX) * 3;

            card.style.transform =
                "translateY(-10px) perspective(800px) rotateX(" +
                rotateX +
                "deg) rotateY(" +
                rotateY +
                "deg)";
        });

        card.style.transition = "transform 0.1s ease";

        card.addEventListener("mouseleave", function () {
            card.style.transform = "";
            card.style.transition = "transform 0.5s ease";
        });
    });
});
