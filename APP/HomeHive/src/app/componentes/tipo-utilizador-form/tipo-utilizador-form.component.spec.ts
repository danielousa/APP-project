import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipoUtilizadorFormComponent } from './tipo-utilizador-form.component';

describe('TipoUtilizadorFormComponent', () => {
  let component: TipoUtilizadorFormComponent;
  let fixture: ComponentFixture<TipoUtilizadorFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipoUtilizadorFormComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(TipoUtilizadorFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
