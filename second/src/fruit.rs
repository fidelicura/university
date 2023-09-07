use std::fmt::Debug;

use bevy::prelude::*;
use rand::{thread_rng, Rng};

const FRUITS: [&str; 14] = [
    "apple",
    "avocado",
    "bananas",
    "blueberries",
    "carrot",
    "cherries",
    "coconut",
    "dragon",
    "grapes",
    "orange",
    "pineapple",
    "raspberries",
    "star",
    "watermelon",
];

static mut FRUIT_SPAWN_TIME: f32 = 2.; // за глобал стейт, конечно, бьют по рукам...

#[derive(Debug, Component)]
pub(crate) struct Fruit {
    lifetime: Timer,
}

impl Fruit {
    pub(crate) fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
        let texture = Self::pick_random(asset_server);
        let position = Self::random_position();
        let sprite = Sprite {
            custom_size: Some(Vec2::new(50., 50.)),
            ..default()
        };

        commands.spawn((
            SpriteBundle {
                sprite,
                transform: position,
                texture,
                ..default()
            },
            Fruit {
                lifetime: Timer::from_seconds(5., TimerMode::Once),
            },
        ));
    }

    fn pick_random(asset_server: Res<AssetServer>) -> Handle<Image> {
        let mut rng = thread_rng();
        let idx = rng.gen_range(0..14) as usize;

        let path = Self::generate_path(FRUITS[idx]);

        asset_server.load(path)
    }

    fn generate_path(fruit_name: &str) -> String {
        format!("fruits/{}.png", fruit_name)
    }

    fn random_position() -> Transform {
        let mut rng = thread_rng();
        let x = rng.gen_range(-170..170) as f32;

        Transform::from_xyz(x, 300., 0.)
    }

    pub(crate) fn movement_handler(mut query: Query<(&mut Transform, &Self)>) {
        query.iter_mut().for_each(|(mut fruit_transform, _)| {
            let fruit_translation = &mut fruit_transform.translation;

            fruit_translation.y -= 5.;
        })
    }

    pub(crate) fn lifetime_handler(
        mut commands: Commands,
        time: Res<Time>,
        mut fruits: Query<(Entity, &mut Self)>,
    ) {
        fruits.iter_mut().for_each(|(entity, mut fruit)| {
            fruit.lifetime.tick(time.delta());

            if fruit.lifetime.finished() {
                commands.entity(entity).despawn();
            }
        })
    }
}

#[derive(Debug, Component)]
pub(crate) struct FruitSpawner;

impl FruitSpawner {
    pub(crate) fn setup(commands: Commands, time: Res<Time>, asset_server: Res<AssetServer>) {
        if time.elapsed_seconds() >= unsafe { FRUIT_SPAWN_TIME } {
            Fruit::setup(commands, asset_server);
            unsafe { FRUIT_SPAWN_TIME += 2. }; // ай-ай-ай
        }
    }
}
