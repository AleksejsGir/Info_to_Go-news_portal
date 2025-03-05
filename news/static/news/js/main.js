document.addEventListener('DOMContentLoaded', function() {
    // Существующий код остается без изменений
    document.querySelector('h1')?.addEventListener('click', () => {
        document.querySelector('h1').classList.toggle('text-danger');
        document.querySelector('h1').classList.toggle('bg-warning');
    });

    // Упрощенная функция для лайков
    const likeButtons = document.querySelectorAll('.like-button');

    likeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const articleId = this.dataset.articleId;
            const heartIcon = this.querySelector('i');
            const likesCountSpan = this.querySelector('.likes-count');

            fetch(`/news/toggle_like/${articleId}/`, {
                method: 'POST',
                headers: {
                    'X-CSRFToken': getCookie('csrftoken')
                }
            })
            .then(response => response.json())
            .then(data => {
                // Обновляем количество лайков
                likesCountSpan.textContent = data.likes_count;

                // Простое переключение класса
                heartIcon.classList.toggle('text-danger');
            })
            .catch(error => {
                console.error('Ошибка при лайке:', error);
            });
        });
    });
});

// Функция для получения CSRF токена
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}