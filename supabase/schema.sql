-- Create events table
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    available_tickets INTEGER NOT NULL DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tickets table
CREATE TABLE tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES events(id),
    user_id UUID REFERENCES auth.users(id),
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample events
INSERT INTO events (title, description, date, price, image_url) VALUES
('Рок-фестиваль "Громче Всех"', 'Грандиозный рок-фестиваль с участием легендарных российских и международных групп. Целый день живой музыки, драйва и незабываемых эмоций!', '2025-07-15 16:00:00+00', 3500.00, 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),

('Гастрономический фестиваль "Вкусы Мира"', 'Уникальное кулинарное путешествие по кухням разных стран. Мастер-классы от известных шеф-поваров, дегустации и развлекательная программа.', '2025-08-20 12:00:00+00', 2800.00, 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),

('Киберспортивный турнир "Digital Battle"', 'Масштабный турнир по популярным киберспортивным дисциплинам. Призовой фонд 1,000,000 рублей! Зрелищные баталии и встречи с известными стримерами.', '2025-09-05 10:00:00+00', 1500.00, 'https://images.unsplash.com/photo-1542751371-adc38448a05e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),

('Театральная премьера "Сон в летнюю ночь"', 'Современная интерпретация классической пьесы Шекспира. Инновационные декорации, талантливый актерский состав и живая музыка.', '2025-06-30 19:00:00+00', 4500.00, 'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),

('Научный фестиваль "Технологии Будущего"', 'Выставка последних достижений в области робототехники, VR/AR и искусственного интеллекта. Интерактивные демонстрации, лекции от ведущих учёных и возможность протестировать новейшие разработки.', '2025-10-15 11:00:00+00', 2000.00, 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80');
