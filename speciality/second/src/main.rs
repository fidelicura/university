mod camera;
mod fruit;
mod player;

use bevy::prelude::*;

use camera::Camera;
use fruit::{Fruit, FruitSpawner};
use player::{Player, PlayerScore};

fn main() {
    App::new()
        // plugins
        .add_plugins(
            DefaultPlugins
                .set(ImagePlugin::default_nearest())
                .set(WindowPlugin {
                    primary_window: Some(Window {
                        title: "Catcher".into(),
                        resolution: (640., 480.).into(),
                        resizable: false,
                        ..default()
                    }),
                    ..default()
                })
                .build(),
        )
        // setup
        .add_systems(Startup, Camera::setup)
        .add_systems(Startup, Player::setup)
        .add_systems(Startup, Fruit::setup)
        // camera
        .add_systems(Update, Camera::update_score)
        // player
        .add_systems(Update, Player::movement_handler)
        .add_systems(Update, Player::hit_fruit)
        .insert_resource(PlayerScore::new(0u16))
        // fruits
        .add_systems(Update, Fruit::movement_handler)
        .add_systems(Update, Fruit::lifetime_handler)
        .add_systems(Update, FruitSpawner::setup)
        // event loop
        .run();
}
