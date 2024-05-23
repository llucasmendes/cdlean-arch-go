//go:build wireinject
// +build wireinject

package main

import (
	"database/sql"
	"github.com/google/wire"
	"github.com/llucasmendes/dcdlean-arch-go/internal/entity"
	"github.com/llucasmendes/dcdlean-arch-go/internal/event"
	"github.com/llucasmendes/dcdlean-arch-go/internal/infra/database"
	"github.com/llucasmendes/dcdlean-arch-go/internal/usecase"
	"github.com/llucasmendes/dcdlean-arch-go/pkg/events"
)

var setOrderRepositoryDependency = wire.NewSet(
	database.NewOrderRepository,
	wire.Bind(new(entity.OrderRepositoryInterface), new(*database.OrderRepository)),
)

var setActionEvent = wire.NewSet(
	event.NewOrderCreatedActionEvent,
	wire.Bind(new(events.EventInterface), new(*event.ActionEvent)),
)

func NewListOrderUseCase(db *sql.DB) *usecase.ListOrderUseCase {
	wire.Build(
		setOrderRepositoryDependency,
		usecase.NewListOrderUseCase,
	)
	return &usecase.ListOrderUseCase{}
}

func NewCreateOrderUseCase(db *sql.DB, eventDispatcher events.EventDispatcherInterface) *usecase.CreateOrderUseCase {
	wire.Build(
		setOrderRepositoryDependency,
		setActionEvent,
		usecase.NewCreateOrderUseCase,
	)
	return &usecase.CreateOrderUseCase{}
}
