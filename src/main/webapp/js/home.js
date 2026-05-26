/*
 * home.js
 *
 * This file is used only for small user interface effects on the home page.
 * It handles scroll reveal animations, number counting animation, and a back-to-top button.
 * It does not perform any backend processing, database work, authentication, or form handling.
 */

document.addEventListener("DOMContentLoaded", function () {

    /*
     * Elements with the class "js-reveal" will fade/slide into view
     * when they become visible on the screen.
     */
    const revealElements = document.querySelectorAll(".js-reveal");

    /*
     * Elements with the class "js-count" display animated numbers.
     * The final number comes from the data-count attribute in index.jsp.
     */
    const countElements = document.querySelectorAll(".js-count");

    /*
     * Optional back-to-top button.
     * If this button is not present on the page, the code safely skips it.
     */
    const backToTopBtn = document.getElementById("backToTopBtn");

    /*
     * IntersectionObserver checks when an element enters the visible area
     * of the browser window. This is used for smooth reveal animations.
     */
    const revealObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {

                // Add a CSS class that triggers the reveal animation.
                entry.target.classList.add("is-visible");

                // Stop observing after the animation has been applied once.
                revealObserver.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.15
    });

    /*
     * Attach the reveal observer to every reveal element.
     */
    revealElements.forEach(function (element) {
        revealObserver.observe(element);
    });

    /*
     * Observer for number counters.
     * The counting animation starts only when the number becomes visible.
     */
    const countObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                animateCount(entry.target);

                // Count only once, not every time the user scrolls.
                countObserver.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.5
    });

    /*
     * Attach the counter observer to every count element.
     */
    countElements.forEach(function (element) {
        countObserver.observe(element);
    });

    /*
     * Animates a number from 0 to its target value.
     * The target value is taken from the data-count attribute.
     */
    function animateCount(element) {
        const targetValue = parseInt(element.getAttribute("data-count"), 10);

        /*
         * If the value is missing or invalid, show 0 instead of causing an error.
         */
        if (isNaN(targetValue)) {
            element.textContent = "0";
            return;
        }

        let currentValue = 0;
        const duration = 900;
        const startTime = performance.now();

        /*
         * requestAnimationFrame is used for smooth browser animation.
         */
        function updateCount(currentTime) {
            const elapsedTime = currentTime - startTime;
            const progress = Math.min(elapsedTime / duration, 1);

            /*
             * Easing makes the number animation feel smoother.
             * It starts quickly and slows down near the final value.
             */
            const easedProgress = 1 - Math.pow(1 - progress, 3);

            currentValue = Math.floor(easedProgress * targetValue);
            element.textContent = currentValue;

            if (progress < 1) {
                requestAnimationFrame(updateCount);
            } else {
                // Make sure the final number is exactly the target value.
                element.textContent = targetValue;
            }
        }

        requestAnimationFrame(updateCount);
    }

    /*
     * Show or hide the back-to-top button depending on scroll position.
     */
    window.addEventListener("scroll", function () {
        if (!backToTopBtn) {
            return;
        }

        if (window.scrollY > 500) {
            backToTopBtn.classList.add("show");
        } else {
            backToTopBtn.classList.remove("show");
        }
    });

    /*
     * When the back-to-top button is clicked, smoothly scroll to the top.
     */
    if (backToTopBtn) {
        backToTopBtn.addEventListener("click", function () {
            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });
        });
    }
});