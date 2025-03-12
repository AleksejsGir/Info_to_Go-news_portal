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

    // Добавляем обработчик для кнопок избранного
    const favoriteButtons = document.querySelectorAll('.favorite-button');

    favoriteButtons.forEach(button => {
        button.addEventListener('click', function() {
            const articleId = this.dataset.articleId;
            const bookmarkIcon = this.querySelector('i');
            const favoritesCountSpan = this.querySelector('.favorites-count');

            fetch(`/news/toggle_favorite/${articleId}/`, {
                method: 'POST',
                headers: {
                    'X-CSRFToken': getCookie('csrftoken')
                }
            })
            .then(response => response.json())
            .then(data => {
                // Обновляем количество добавлений в избранное
                favoritesCountSpan.textContent = data.favorites_count;

                // Переключаем иконку избранного
                if (data.is_favorite) {
                    bookmarkIcon.classList.remove('bi-bookmark');
                    bookmarkIcon.classList.add('bi-bookmark-fill');
                } else {
                    bookmarkIcon.classList.remove('bi-bookmark-fill');
                    bookmarkIcon.classList.add('bi-bookmark');
                }
            })
            .catch(error => {
                console.error('Ошибка при добавлении в избранное:', error);
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